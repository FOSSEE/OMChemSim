within Simulator.UnitOperations;

model HeatExchanger
  extends Simulator.Files.Icons.HeatExchanger;
  //Heat-Exchanger Operates in various modes
  //Mode-I - Estimation of Hot Fluid Outlet Temperature
  //      Inputs : Pdelh,deltap_cold,Heat_Loss,Tcout,Flow Direction,Name of the calculation type,Area
  //Mode-II - Estimation of Cold Fluid Outlet Temperature
  //      Inputs : Pdelh,deltap_cold,Heat_Loss,Thout,Flow Direction,Name of the calculation type,Area
  //Mode-III - Estimation of Both the fluid outlet temperature
  //      Inputs : Pdelh,deltap_cold,Heat_Loss,Qact,Flow Direction,Name of the calculation type,Area
  //Mode-IV - Estimation of both the fluid outlet temperature-NTU Method
  //      Inputs : Pdelh,deltap_cold,Heat_Loss,U,Flow Direction,Name of the calculation type,Area
  //Mode-V-Estimation of Heat Transfer Area
  //      Inputs : Pdelh,deltap_cold,Heat_Loss,U,Flow Direction,Name of the calculation type
  //Mode-VI-Estimation of all parameters given the heat transfer Eff
  //      Inputs : Pdelh,deltap_cold,Heat_Loss,U,Eff,Flow Direction,Name of the calculation type
  
  import Simulator.Files.*;
  import Simulator.Files.Thermodynamic_Functions.*;
  parameter Simulator.Files.ChemsepDatabase.GeneralProperties C[Nc];
  parameter Integer Nc "number of compounds ";
  Simulator.Files.Interfaces.matConn In_Hot(Nc = Nc) annotation(
    Placement(visible = true, transformation(origin = {-74, 38}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Simulator.Files.Interfaces.matConn Out_Hot(Nc = Nc) annotation(
    Placement(visible = true, transformation(origin = {80, 38}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Simulator.Files.Interfaces.matConn In_Cold(Nc = Nc) annotation(
    Placement(visible = true, transformation(origin = {-74, -28}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {0, 100}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Simulator.Files.Interfaces.matConn Out_Cold(Nc = Nc) annotation(
    Placement(visible = true, transformation(origin = {76, -30}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {0, -100}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  //Parameters
  //Mode-I -Outlet Temperature-Hot Stream Calculaions
  parameter Real Qloss = 0;
  parameter Real Pdelh = 0;
  parameter Real Pdelc = 0;
  parameter String Mode"''CoCurrent'',''CounterCurrent''";
  parameter String Cmode"''BothOutletTemp(UA)''";
  Real mu_c,mu_h,k_c,k_h,rho_c,rho_h,MW_h,MW_c;
  //Variables
  //Hot Stream Inlet
  Real Phin(start=Pg);
  Real Thin(start=Tg);
  Real Fhin(start=Fg);
  Real Hhin(start=Htotg);
  Real Shin;
  Real xhin_pc[2, Nc](start={xg,xg});
  Real xvaphin(start=xvapg);
  //Hot Stream Outlet
  Real Phout(start=Pg);
  Real Thout(start=Tg);
  Real Fhout(start=Fg);
  Real Hhout(start=Htotg);
  Real Shout;
  Real xhout_pc[2, Nc](start={xg,xg});
  Real xvaphout;
  //Cold Stream Inlet
  Real Pcin(start=Pg);
  Real Tcin(start=Tg);
  Real Fcin[1](start=Fg);
  Real Hcin(start=Htotg);
  Real Scin;
  Real xcin_pc[2, Nc];
  Real xvapcin(start=xvapg);
  //Cold Stream Outlet
  Real Pcout(start=Pg);
  Real Tcout(start=Tg);
  Real couttT(start=Tg);
  Real Fcout[1](start=Fg);
  Real Hcout(start=Htotg);
  Real Scout;
  Real xcout_pc[2, Nc](start={xg,xg});
  Real xvapcout(start=xvapg);
  
  Real Qact(start = 2000) "Actual Heat Load";
  Real Qmax, Qmaxh, Qmaxc;
  //Hot Stream Enthalpy at Cold Stream Inlet Temperature
  Real Hhin_pc[2, Nc];
  Real Hhin_p[3](start={Htotg,Hliqg,Hvapg});
  //Cold Stream Enthalpy at Hot Stream Inlet Temperature
  Real Hcin_pc[2, Nc];
  Real Hcin_p[3](start={Htotg,Hliqg,Hvapg});
  Real Hdel;
  //Heat Exchanger Effeciency
  Real Eff(start=xliqg);
  //LMTD
  Real Tdel1(start = Tg), Tdel2(start = Tg);
  Real LMTDf "Final Log Mean Temperature Difference";
  Real LMTD"LMTD estimated by other modes";
  //Global Heat Transfer Coefficient
  Real U(start=Fg),Uf(start=Fg);
  //Heat Transfer A
  Real Af"Final Heat Transfer Area",A;
  
  //==========================================================================================================
  //Mode-4-NTU Method-when both the outlet temperatures are unknown
  //Heat Capacity Rate for hot and cold fluid
  Real Cc, Ch;
  //Number of Transfer Units for Hot Side and Cold Side
  Real Ntuc, Ntuh;
  //Heat Capacity Ratio for hot and cold side
  Real Rc, Rh;
  //Effectiveness Factor
  Real Effc, Effh;
//==============================================================================================================  
//==============================================================================================================
  parameter String Case = "Cold in Tube";
  //Case -Refers to the type of Fluid in the Tubes
  //Case-1 - Cold Fluid in Tubes
  //Case-2 - Hot  Fluid in Tubes

  parameter String Layout = "Square";
  //Layout - Referes to the Tube Layout arrangment
  //Layout-1 - Triangle
  //Layout-2 - Rotated Triangle
  //Layout-3 - Square
  //Layout-4 - Rotated Square
   
   
  //Mass Parameters
   Real MWhin,MWcin,MWhout,MWcout;
   Real Cph_pc[3,Nc], Cpc_pc[3,Nc],Cph_p[3],Cpc_p[3],Cphin,Cpcin; 
   Real Fmhin,Fmcin;
   
  //Design Rating Parameters and Variables
  Real f1,f2,f3,f4,f5;
  
  Real Fx,Fy,Fl;
  
  //Parameters used to compute LMTD correction factor
  Real R(start=6);
  Real P(start=5);
  Real S(start=6);
  Real W(start=5);
  Real LMTDr(start=20) "Log Mean Temperature Difference";
  Real Tdel3(start=20);
  Real Tdel4(start=30);
  Real LMTDc(start=30) "Corrected Log Mean Temperature Difference";
  
  //Heat Exchanger Geometry
  //Tube-Side Specifications
  parameter Real Do(unit = "mm") = 19.04999 "External diameter of the tube";
  parameter Real Di(unit = "mm") = 14.83004 "Internal diameter of the tube";
  parameter Real L(unit = "m") = 6.5 "Tube Length";
  parameter Real Pt(unit = "mm") = 25.39999 "Tube Spacing";
  parameter Real n = 2 "Number of Shell Passes";
  parameter Real Nts =500 "Tube Number per Shell";
  parameter Real Tube_F(unit = "K.m^2/W") = 0.00035222 "Tube side Fouling Fractor";
  parameter Real kt(unit = "W/m.K") = 70 "Thermal Conductivity of the tube material";
  parameter Real Epsilon(unit = "mm") = 0.045 "Roughness";
  
  //===========================================================================================
  //Shell Side Specifications
  parameter Real Shells = 1 "Number of Shells in Series";
  parameter Real nt = 2 "Number of Tube Passes per shell";
  parameter Real Dsi(unit = "mm") = 736.5996 "Shell Internal Diameter";
  parameter Real Baffle_Cut(unit = "%") = 25;
  parameter Real Baffle_Spacing(unit = "mm") = 406.40003 "Baffle Spacing";
  parameter Real Shell_F(unit = "K.m^2/W") = 0.0005283309 "Shell side Fouling Factor";
  //==========================================================================================
  //Thermo-Physical Properties evaluated at repsective temperatures
  //==============================================================================================
  //Density of individual components in units = mol/m^3
  Real rho1[Nc](each unit = "mol/m^3");
  Real rho2[Nc](each unit = "mol/m^3");
  Real rho3[Nc](each unit = "mol/m^3");
  Real rho4[Nc](each unit = "mol/m^3");
  //Density of Inlet and Outlet Streams in units = kg/m^3
  Real rho_cin(unit = "kg/m^3");
  Real rho_hin(unit = "kg/m^3");
  Real rho_cout(unit = "kg/m^3");
  Real rho_hout(unit = "kg/m^3");
  //Viscocity of individual components in units = Pas
  Real mu1[Nc](each unit = "Pas");
  Real mu2[Nc](each unit = "Pas");
  Real mu3[Nc](each unit = "Pas");
  Real mu4[Nc](each unit = "Pas");
  //Viscocity of Inlet and Outlet Streams in units = Pas
  Real mu_cin(unit = "Pas");
  Real mu_hin(unit = "Pas");
  Real mu_cout(unit = "Pas");
  Real mu_hout(unit = "Pas");
  //Thermal Conductivity of induvidual components in units = W/m.K
  Real k1[Nc](each unit = "W/m.K");
  Real k2[Nc](each unit = "W/m.K");
  Real k3[Nc](each unit = "W/m.K");
  Real k4[Nc](each unit = "W/m.K");
  //Thermal Conductivity of Inlet and Outlet streams in units = W/m.K
  Real k_cin(unit = "W/m.K");
  Real k_hin(unit = "W/m.K");
  Real k_cout(unit = "W/m.K");
  Real k_hout(unit = "W/m.K");
  //==============================================================================================
  Real Area(unit = "m^2") "Flow area in the inner section of the tubes";
  Real Atc;
     
  Real E_D "Roughness Factor";
  //Constants to evaluate Friction Factor
  Real a1;
  Real b1;
  Real f "Friction Factor-Tube Side";
  Real Nt;
  Real vt(unit = "m/s") "Average speed of the fluid flowing within the tubes";
  Real Ret "Reynolds Number for the flow in the tubes";
  Real Prt "Prandtl Number for tube side fluid";
  Real Pdelt(unit = "Pa",start=Pg) "Tube side Pressure Drop";
  Real hi(unit = "W/m^2.K") "Tube Side Heat Transfer Coefficient";
  //Parameters for Tube Layout Geometry
  Real xx, yy;
  Real Nh, Y, Np;

  Real Z;
  //Shell Side Parameters
  Real nsc;
  Real Hdi;
  Real Nb "Number of Baffles";
  Real Dsf;
  Real Fp;
  Real Cb;
  Real Ca;
  Real Ss;
  Real Ssf;
  Real Gsf;
  Real Res "Shell Side Reynolds Number";
  Real Prs "Shell side Prandtl Number";
  Real jh;
  Real fs "Shell Side Friction Factor";
  Real Cx;
  Real Pdels(unit = "Pa",start=Pg) "Shell side Pressure Drop";
  Real Fh;
  Real Ssh(unit = "m^2") "Effective area of flow section";
  Real Gsh;
  Real Rsh;
  Real lb;
  Real Ec;
  Real he(unit = "W/m^2.K") "Shell Side Heat Transfer Coefficient";
  
  protected
  parameter Real aa1 = 0.9078565328950;
  parameter Real bb1 = 0.6633110612656;
  parameter Real cc1 = -4.432976463965;
  parameter Real aa2 = 5.3718559074820;
  parameter Real bb2 = -0.334167651380;
  parameter Real cc2 = 0.7267144209289;
  parameter Real aa3 = 0.5380765047084;
  parameter Real bb3 = 0.3761125784041;
  parameter Real cc3 = -3.874122438618;
  parameter Real aa4 = 0.8413482436171;
  parameter Real bb4 = 0.6137452048509;
  parameter Real cc4 = -4.269631846617;
  parameter Real aa5 = 4.9901814007765;
  parameter Real bb5 = -0.324374425103;
  parameter Real cc5 = 1.0848504232691;
  parameter Real aa6 = 0.5502379008813;
  parameter Real bb6 = 0.3655956022543;
  parameter Real cc6 = -3.990413056254;
  parameter Real aa7 = 0.6673865440676;
  parameter Real bb7 = 0.6802600338862;
  parameter Real cc7 = -4.522291113086;
  parameter Real aa8 = 4.5749169651729;
  parameter Real bb8 = -0.322017594423;
  parameter Real cc8 = 1.1729518374369;
  parameter Real aa9 = 0.3686963113096;
  parameter Real bb9 = 0.3839785947581;
  parameter Real cc9 = -3.627346599678;
  parameter Real F =0.9828;
  parameter Real m = 0.96;
//=========================================================================================================== 
 extends GuessModels.InitialGuess;
equation
//Hot Stream Inlet
  In_Hot.P = Phin;
  In_Hot.T = Thin;
  In_Hot.F = Fhin;
  In_Hot.H = Hhin;
  In_Hot.S = Shin;
  In_Hot.x_pc[1, :] = xhin_pc[1, :];
  In_Hot.x_pc[2, :] = xhin_pc[2, :];
  In_Hot.xvap = xvaphin;
//Hot Stream Outlet
  Out_Hot.P = Phout;
  Out_Hot.T = Thout;
  Out_Hot.F = Fhout;
  Out_Hot.H = Hhout;
  Out_Hot.S = Shout;
  Out_Hot.x_pc[1, :] = xhout_pc[1, :];
  Out_Hot.x_pc[2, :] = xhout_pc[2, :];
  Out_Hot.xvap = xvaphout;
//Cold Stream In
  In_Cold.P = Pcin;
  In_Cold.T = Tcin;
  In_Cold.F = Fcin[1];
  In_Cold.H = Hcin;
  In_Cold.S = Scin;
  In_Cold.x_pc[1, :] = xcin_pc[1, :];
  In_Cold.x_pc[2, :] = xcin_pc[2, :];
  In_Cold.xvap = xvapcin;
//Cold Stream Out
  Out_Cold.P = Pcout;
  Out_Cold.T = couttT;
  Out_Cold.F = Fcout[1];
  Out_Cold.H = Hcout;
  Out_Cold.S = Scout;
  Out_Cold.x_pc[1, :] = xcout_pc[1, :];
  Out_Cold.x_pc[2, :] = xcout_pc[2, :];
  Out_Cold.xvap = xvapcout;
equation
  Fhin = Fhout;
  Fcin[1] = Fcout[1];
  xhin_pc[1] = xhout_pc[1];
  xcin_pc[1] = xcout_pc[1];
  Phout = Phin - Pdelh;
  Pcout = Pcin - Pdelc;
  Qact = Fcin[1] * (Hcout - Hcin);
  Hdel = -(Qact + Qloss * 1000) / Fhin;
  if Cmode == "BothOutletTemp(UA)" then
    Hhout = Hhin - Qact / Fhin - Qloss * 1000 / Fhin;
    Tcout = Tcin + Effc * (Thin - Tcin);
  else
    Tcout = couttT;
    Hhout = Hhin + Hdel;
  end if;
//==========================================================================================================
//Calculation of Hot Stream Enthalpy at  Cold Stream Inlet Temperature
  for i in 1:Nc loop
    Hhin_pc[1, i] = ThermodynamicFunctions.HLiqId(C[i].SH, C[i].VapCp, C[i].HOV, C[i].Tc, Tcin);
    Hhin_pc[2, i] = ThermodynamicFunctions.HVapId(C[i].SH, C[i].VapCp, C[i].HOV, C[i].Tc, Tcin);
  end for;
  for i in 1:2 loop
    Hhin_p[i] = sum(xhin_pc[i, :] .* Hhin_pc[i, :]);
/*+ inResMolEnth[2, i]*/
  end for;
  Hhin_p[3] = (1 - xvaphin) * Hhin_p[1] + xvaphin * Hhin_p[2];
//Maximum Theoritical Heat Exchange-Hot Fluid
  Qmaxh = Fhin * (Hhin - Hhin_p[3]);
//===========================================================================================================
//Enthalpy of Cold Stream Enthalpy at Hot Fluid Inlet Temperature
  for i in 1:Nc loop
    Hcin_pc[1, i] = ThermodynamicFunctions.HLiqId(C[i].SH, C[i].VapCp, C[i].HOV, C[i].Tc, Thin);
    Hcin_pc[2, i] = ThermodynamicFunctions.HVapId(C[i].SH, C[i].VapCp, C[i].HOV, C[i].Tc, Thin);
  end for;
  for i in 1:2 loop
    Hcin_p[i] = sum(xcin_pc[i, :] .* Hcin_pc[i, :]);
/*+ inResMolEnth[1, i]*/
  end for;
  Hcin_p[3] = (1 - xvapcin) * Hcin_p[1] + xvapcin * Hcin_p[2];
//Maximum Theoritical Heat Exchange- Cold Fluid
  Qmaxc = Fcin[1] * abs(Hcin - Hcin_p[3]);
//Maximum Heat Exchange
  Qmax = min(Qmaxh, Qmaxc);
  Eff = (Qact - Qloss * 1000) / Qmax * 100;
//Log Mean Temperature Difference
  if(Mode=="CoCurrent") then
    Tdel1 =Thin-Tcin;
    Tdel2 =Thout-Tcout;  
  elseif Mode=="CounterCurrent" then
    Tdel1 =Thin-Tcout;
    Tdel2 =Thout-Tcin;
  end if;
  
  if Tdel1 <= 0 or Tdel2 <= 0 then
    LMTD = 1;
  else
    LMTD = (Tdel1 - Tdel2) / log(Tdel1 / Tdel2);
  end if;

//NTU-Method
  Cc = Fcin[1] * ((Hcout - Hcin) / (Tcout - Tcin));
  Ch = Fhin * ((Hhout - Hhin) / (Thout - Thin));
//Number of Transfer Units
  Ntuc = U * A / Cc;
  Ntuh = U * A / Ch;
//Heat Capacity Ratio for Hot and Cold Side
  Rc = Cc / Ch;
  Rh = Ch / Cc;
  

  if Mode=="CoCurrent" then
    Effc = (1- exp(-Ntuc * (1+Rc)))/(1+Rc);
    Effh =  (1- exp(-Ntuh * (1+Rh)))/(1+Rh);
  elseif Mode=="CounterCurrent" then
    Effc = (1-exp((Rc-1)*Ntuc))/(1 -Rc*  exp((Rc-1)*Ntuc));
    Effh =  (1-exp((Rh-1) *Ntuh ))/(1 -Rh *  exp((Rh-1)*Ntuh));
  end if;
 
//=========================================================================================================  
  Uf = (Qact) / (Af * LMTDf);
//===========================================================================================================
f1 = Do * 1E-3 / (hi * (Di * 1E-3));
f2 = Tube_F * (Do * 1E-3) / (Di * 1E-3);
f3 = Do * 1E-3 / (2 * kt) * log(Do / Di);
f4 = Shell_F;
f5 = 1 / he;

//Estimation of Shell side Heat Transfer Coefficient
  Fh = 1 / (1 + Nh * (Dsi / Pt) ^ 0.5);
  Ssh = Ss * m / Fh;
  lb = Baffle_Spacing * 1E-3 * (Nb - 1);
  if L == lb then
    Ec = 1;
  else
    Ec = (lb + (L - lb) * (2 * (Baffle_Spacing * 1E-3) / (L - lb)) ^ 0.6) / L;
  end if;
//==============================================================================================================
  if Case == "Cold in Tube" then
    Gsh = Fmhin / Ssh;
    Rsh = Gsh * (Do * 1E-3) / mu_h;
    he = jh * k_h * (Prs ^ 0.34 / (Do * 1E-3)) * Ec;
  else
    Gsh = Fmcin / Ssh;
    Rsh = Gsh * (Do * 1E-3) / mu_c;
    he = jh * k_c * Prs ^ 0.34 / (Do * 1E-3) * Ec;
  end if;
//==============================================================================================================
//Shell-Side Pressure Drop
  if Case == "Cold in Tube" then
    Pdels = 4 * fs * Gsf ^ 2 / (2 * rho_h) * Cx * (1 - Hdi) * (Dsi / Pt) * Nb * (1 + Y * (Pt / Dsi)) * Shells;
  else
    Pdels = 4 * fs * Gsf ^ 2 / (2 * rho_c) * Cx * (1 - Hdi) * (Dsi / Pt) * Nb * (1 + Y * (Pt / Dsi)) * Shells;
  end if;
//==============================================================================================================
//============================================================================================================
//Computation of Friction Factor for Shell Side Flow
  if Layout == "Triangle" and Layout == "Rotated Triangle" then
    if Res < 100 then
      jh = 0.497 * Rsh ^ 0.54;
    else
      jh = 0.378 * Rsh ^ 0.59;
    end if;
//============================================================================================================
    if Z <= 1.2 then
      if Res < 100 then
        fs = 276.46 * Res ^ (-0.979);
      elseif Res < 1000 then
        fs = 30.26 * Res ^ (-0.523);
      else
        fs = 2.93 * Res ^ (-0.186);
      end if;
    elseif Z <= 1.3 then
      if Res < 100 then
        fs = 208.14 * Res ^ (-0.945);
      elseif Res < 1000 then
        fs = 27.6 * Res ^ (-0.525);
      else
        fs = 2.27 * Res ^ (-0.163);
      end if;
    elseif Z <= 1.4 then
      if Res < 100 then
        fs = 122.73 * Res ^ (-0.865);
      elseif Res < 1000 then
        fs = 17.82 * Res ^ (-0.474);
      else
        fs = 1.86 * Res ^ (-0.146);
      end if;
    else
      if Res < 100 then
        fs = 104.33 * Res ^ (-0.869);
      elseif Res < 1000 then
        fs = 12.69 * Res ^ (-0.434);
      else
        fs = 1.526 * Res ^ (-0.129);
      end if;
    end if;
//==================================================================================================
  else
    if Res < 100 then
      jh = 0.385 * Rsh ^ 0.526;
    else
      jh = 0.2487 * Rsh ^ 0.625;
    end if;
//===================================================================================================
    if Z <= 1.2 then
      if Res < 100 then
        fs = 230 * Res ^ (-1);
      elseif Res < 1000 then
        fs = 16.23 * Res ^ (-0.43);
      else
        fs = 2.67 * Res ^ (-0.173);
      end if;
    elseif Z <= 1.3 then
      if Res < 100 then
        fs = 142.22 * Res ^ (-0.949);
      elseif Res < 1000 then
        fs = 11.93 * Res ^ (-0.43);
      else
        fs = 1.77 * Res ^ (-0.144);
      end if;
    elseif Z <= 1.4 then
      if Res < 100 then
        fs = 110.77 * Res ^ (-0.965);
      elseif Res < 1000 then
        fs = 7.524 * Res ^ (-0.4);
      else
        fs = 1.01 * Res ^ (-0.104);
      end if;
    else
      if Res < 100 then
        fs = 58.18 * Res ^ (-0.862);
      elseif Res < 1000 then
        fs = 6.76 * Res ^ (-0.411);
      else
        fs = 0.718 * Res ^ (-0.008);
      end if;
    end if;
  end if;
//==============================================================================================================
//Cx values with respect to Tube_Layout
  if Layout == "Triangle" and Layout == "Rotated Triangle" then
    Cx = 1.154;
  elseif Layout == "Square" then
    Cx = 1;
  else
    Cx = 1.414;
  end if;
//============================================================================================================
//=============================================================================================================
//Calculation of Reynolds Number for Shell Side
  if Case == "Cold in Tube" then
    Gsf = Fmhin / Ssf;
    Res = Gsf * (Do * 1E-3) / mu_h;
    Prs = mu_h * (Cphin / MW_h) / (k_h * 1E-3);
  else
    Gsf = Fmcin / Ssf;
    Res = Gsf * (Do * 1E-3) / mu_c;
    Prs = mu_c * (Cpcin / MW_c) / (k_c * 1E-3);
  end if;
  Z = Pt / Do;
//=============================================================================================================  
//======================================================================================================
//Shell-Side Calculations
  if Layout == "Triangle" and Layout == "Rotated Triangle" then
    nsc = 1.1 * Nts ^ 0.5;
  else
    nsc = 1.19 * Nts ^ 0.5;
  end if;
  Dsf = (nsc - 1) * (Pt * 1E-3) + Do * 1E-3;
  Hdi = Baffle_Cut / 100;
  Nb = L / (Baffle_Spacing * 1E-3) + 1;
//Calculation of Shell Side Pressure Drop
  xx = Dsi / Baffle_Spacing;
  yy = Pt / Do;
  if Layout == "Triangle" and Layout == "Rotated Triangle" then
    Nh = aa1 * xx ^ bb1 * yy ^ cc1;
    Y = aa2 * xx ^ bb2 * yy ^ cc2;
    Np = aa3 * xx ^ bb3 * yy ^ cc3;
    Cb = 0.97;
  elseif Layout == "Square" then
    Nh = aa4 * xx ^ bb4 * yy ^ cc4;
    Y = aa5 * xx ^ bb5 * yy ^ cc5;
    Np = aa6 * xx ^ bb6 * yy ^ cc6;
    Cb = 0.97;
  else
    Nh = aa7 * xx ^ bb7 * yy ^ cc7;
    Y = aa8 * xx ^ bb8 * yy ^ cc8;
    Np = aa9 * xx ^ bb9 * yy ^ cc9;
    Cb = 1.37;
  end if;
  Fp = 1 / (0.8 + Np * (Dsi * 1E-3 / (Pt * 1E-3)) ^ 0.5);
  Ca = Cb * (Pt * 1E-3 - Do * 1E-3) / (Pt * 1E-3);
  Ss = Ca * (Baffle_Spacing * 1E-3) * Dsf;
  Ssf = Ss / Fp;
//========================================================================================================

//=============================================================================================================
//Computation of Tube Side Pressure Dropf
  if Case == "Cold in Tube" then
    Pdelt = f * L * (nt / (Di * 1E-3)) * (vt ^ 2 / 2) * rho_c;
    hi * Di * 1E-3 / k_c = f / 8 * Ret * (Prt / (1.07 + 12.7 * (f / 8) ^ 0.5 * (Prt ^ (2 / 3) - 1)));
  else
    Pdelt = f * L * nt / (Di * 1E-3 * (vt ^ 2 / 2) * rho_h);
    hi * (Di * 1E-3) / k_h = f / 8 * Ret * Prt / (1.07 + 12.7 * (f / 8) ^ 0.5 * (Prt ^ (2 / 3) - 1));
  end if;
//===========================================================================================================
//===========================================================================================================
//Calculation of Friction Factor
  E_D = Epsilon / Di;
  if Ret > 3250 then
    a1 = log10(E_D ^ 1.1096 / 2.8257 + (7.149 / Ret) ^ 0.8961);
    b1 = -2 * log10(E_D / 3.7065 - 5.0452 * a1 / Ret);
    f = (1 / b1) ^ 2 * 1.2;
  else
    a1 = 0;
    b1 = 0;
    f = 64 / Ret * 1.2;
  end if;
//===========================================================================================================
  Area = 3.14 * (Di * 1E-3) ^ 2 / 4;
  if Case == "Cold in Tube" then
    vt = Fmcin / (rho_c * Nt * Area);
    Ret = rho_c * vt * (Di * 1E-3) / mu_c;
    Prt = mu_c * (Cpcin / MW_c) / (k_c * 1E-3);
  else
    vt = Fmhin / (rho_h * Nt * (3.14 / 4 * (Di * 1E-3) ^ 2));
    Ret = rho_h * vt * (Di * 1E-3) / mu_h;
    Prt = mu_h * (Cphin / MW_h) / (k_h * 1E-3);
  end if;
//===========================================================================================================
 //Calculation of Thermo-Physical Properties
//===========================================================================================================
  for i in 1:Nc loop
    rho1[i] = ThermodynamicFunctions.Dens(C[i].LiqDen, C[i].Tc, (Tcin + Tcout) / 2, Pcin);
    rho2[i] = ThermodynamicFunctions.Dens(C[i].LiqDen, C[i].Tc, (Thin + Thout) / 2, Phin);
    rho3[i] = ThermodynamicFunctions.Dens(C[i].LiqDen, C[i].Tc, (Tcin + Tcout) / 2, Pcout);
    rho4[i] = ThermodynamicFunctions.Dens(C[i].LiqDen, C[i].Tc, (Thin + Thout) / 2, Phout);
  end for;
  rho_cin = sum(xcin_pc[1, :] .* rho1[:]) * 1E-3 * MWcin;
  rho_hin = sum(xhin_pc[1, :] .* rho2[:]) * 1E-3 * MWhin;
  rho_cout = sum(xcout_pc[1, :] .* rho3[:]) * 1E-3 * MWcout;
  rho_hout = sum(xhout_pc[1, :] .* rho4[:]) * 1E-3 * MWhout;
//rho_cin = 1035.41732;
//rho_hin = 669.43412;
//rho_hout = 705.29712;
//rho_cout = 1020.06001;
rho_c = (rho_cin + rho_cout)/2;
rho_h = (rho_hin + rho_hout)/2;
//=======================================================================================================
  for i in 1:Nc loop
    mu1[i] = Simulator.Files.TransportProperties.LiqVis(C[i].LiqVis, (Tcin + Tcout) / 2);
    mu2[i] = Simulator.Files.TransportProperties.LiqVis(C[i].LiqVis, (Thin + Thout) / 2);
    mu3[i] = Simulator.Files.TransportProperties.LiqVis(C[i].LiqVis, (Tcin + Tcout) / 2);
    mu4[i] = Simulator.Files.TransportProperties.LiqVis(C[i].LiqVis, (Thin + Thout) / 2);
  end for;
  mu_cin = sum(xcin_pc[1, :] .* mu1[:]);
  mu_hin = sum(xhin_pc[1, :] .* mu2[:]);
  mu_cout =sum(xcout_pc[1, :] .* mu3[:]);
  mu_hout =sum(xhout_pc[1, :] .* mu4[:]);
//mu_cin = 0.000801837023398036 ;
//mu_cout = 0.000603245481110247  ;
//mu_hin = 0.000350348400808961 ;
//mu_hout = 0.000545155323029587;
mu_c = (mu_cin + mu_cout)/2;
mu_h = (mu_hin + mu_hout)/2;
//==========================================================================================================
  for i in 1:Nc loop
    k1[i] = Simulator.Files.TransportProperties.LiqK(C[i].LiqK, (Tcin + Tcout) / 2);
    k2[i] = Simulator.Files.TransportProperties.LiqK(C[i].LiqK, (Thin + Thout) / 2);
    k3[i] = Simulator.Files.TransportProperties.LiqK(C[i].LiqK, (Tcin + Tcout) / 2);
    k4[i] = Simulator.Files.TransportProperties.LiqK(C[i].LiqK, (Thin + Thout) / 2);
  end for;
  k_cin = sum(xcin_pc[1, :] .* k1[:]);
  k_hin = sum(xhin_pc[1, :] .* k2[:]);
  k_cout = sum(xcout_pc[1, :] .* k3[:]);
  k_hout = sum(xhout_pc[1, :] .* k4[:]);
//k_cin =0.304;
//k_hin =0.11505;
//k_cout = 0.29663;
//k_hout = 0.12535; 
k_c = (k_cin + k_cout)/2;
k_h = (k_hin + k_hout)/2;
//========================================================================================================= 
  Atc = Af / Shells;
//=======================================================================================================
  Nt = Nts / nt; 
//=======================================================================================================  
//Calculation of Corrected LMTD
if Case == "Cold in Tube" then
    R = (Thin - Thout) / (Tcout - Tcin);
    P = (Tcout - Tcin) / (Thin - Tcin);
  else
    Thout = P * (Tcin - Thin) + Thin;
    Tcout = Tcin - R * (Thout - Thin);
  end if;
//===================================================================================================
  if Mode == "CounterCurrent" then
    Tdel3 = Thin -Tcout;
    Tdel4 = Thout - Tcin;
  else
    Tdel3 = Thin - Tcin;
    Tdel4 = Thout - Tcout;
  end if;
//==================================================================================================
if Tdel3 <= 0 or Tdel4 <= 0 then
    LMTDr = 1;
  else
    LMTDr = (Tdel3 - Tdel4) / log(Tdel3 / Tdel4);
  end if;  
  S = (R ^ 2 + 1) ^ 0.5 / (R - 1);
//Parameters to evaluate the LMTD correction Factor
  if R == 1 then
    W = (n -( n * P)) / (n - (n * P + P));
    Fx = (W / (1 - W) + 1 / 2 ^ 0.5);
    Fy = (W / (1 - W) - 1 / 2 ^ 0.5);
    Fl = 1.414 * ((1 - W) / W);
//    F = 2 ^ 0.5 * ((1 - W) / W) / log((W / (1 - W) + 1 / 2 ^ 0.5) / (W / (1 - W) - 1 / 2 ^ 0.5));
  else
    W = ((1 - P * R) / (1 - P)) ^ (1 / n);
    Fx = (1 + W - S + S * W);
    Fy = (1 + W + S - S * W);
    Fl = S * log(W);
//    F = Fl*Fz;
//    F = S * log(W) / log((1 + W - S + S * W) / (1 + W + S - S * W));
  end if;
//  W = 0.64;

//Corrected LMTD
LMTDc = LMTDr * F;

//=================================================================================================
if(Cmode  == "Design") then 
Af = Nts * 3.14 * (Do * 1E-3) * (L - 2 * Do * 1E-3);
Uf =1/(f1+f2+f3+f4+f5);
LMTDf = LMTDc;
U =0;
A=0;
else
Uf = U;
Af = A;
LMTDf = LMTD;
end if;
//=====================================================================================================
//Specific Heat Routine for Hot-Inlet
for i in 1:Nc loop
Cph_pc[2, i] = ThermodynamicFunctions.LiqCpId(C[i].LiqCp, Thin);
Cph_pc[3, i] = ThermodynamicFunctions.VapCpId(C[i].VapCp, Thin);
end for;
//==================================================================================================
 for i in 2:3 loop
    Cph_p[i] = sum(xhin_pc[i, :] .* Cph_pc[i, :]);
  end for;
 Cph_p[1] = (1-xvaphin) * Cph_p[2] + xvaphin * Cph_p[3];  
 Cph_pc[1, :] = xhin_pc[1, :] .* Cph_p[1];
 Cphin = Cph_p[1]; 
 
//Specific Heat Routine for Cold-Inlet
for i in 1:Nc loop
Cpc_pc[2, i] = ThermodynamicFunctions.LiqCpId(C[i].LiqCp, Tcin);
Cpc_pc[3, i] = ThermodynamicFunctions.VapCpId(C[i].VapCp, Tcin);
end for;

 for i in 2:3 loop
    Cpc_p[i] = sum(xcin_pc[i, :] .* Cpc_pc[i, :]);
  end for;
 Cpc_p[1] = (1-xvapcin) * Cpc_p[2] + xvapcin * Cpc_p[3]; 
 Cpc_pc[1, :] = xcin_pc[1, :] .* Cpc_p[1];  
 Cpcin = Cpc_p[1];
 //=====================================================================================================
//======================================================================================================== 
  Fmhin = Fhin * MWhin*1E-3;
  Fmcin = Fcin[1] * MWcin*1E-3;
//=========================================================================================================
//==========================================================================================================
  MW_h = (MWhin+MWhout)/2;
  MW_c = (MWcin + MWcout)/2;
algorithm
  for i in 1:Nc loop
    MWhin  :=  MWhin  +  C[i].MW *   xhin_pc[1,i];
    MWhout :=  MWhout +  C[i].MW *   xhout_pc[1,i];
    MWcin  :=  MWcin  +  C[i].MW *   xcin_pc[1,i];
    MWcout :=  MWcout +  C[i].MW *   xcout_pc[1,i];
  end for;   

end HeatExchanger;
