within Simulator;

package Unit_Operations
  model Mixer
    extends Simulator.Files.Icons.Mixer;
    import Simulator.Files.*;
    parameter Integer NOC "Number of Components", NI = 6 "Number of Input streams";
    parameter Chemsep_Database.General_Properties comp[NOC];
    parameter String outPress;
    Real outP(start = Press), inP[NI](start = Press);
    Real inCompMolFrac[NI, NOC](each start = 1 / (NOC + 1), each min = 0, each max = 1) "Input stream component mol fraction", inMolFlo[NI](each min = 0, each start = 100) "Input stream Molar Flow";
    Real outCompMolFrac[NOC](each min = 0, each max = 1, start = CompMolFrac) "Output Stream component mol fraction", outMolFlo(each min = 0, start = Feed_flow) "Output stream Molar Flow";
    Real inTotMolEnth[NI] "Inlet molar enthalpy of each stream", outTotMolEnth "Outlet molar enthalpy";
    Real inT[NI](each min = 0, each start = Temp) "Temperature of each stream", outT(start = Temp) "Temperature of outlet stream", inTotMolEntr[NI] "Inlet molar enthalpy of each stream", outTotMolEntr "Outlet molar entropy", inVapPhasMolFrac[NI](each min = 0, each max = 1, each start = 0.5) "Inlet vapor phase mol fraction", outVapPhasMolFrac(min = 0, max = 1, start = Beta_guess) "Outlet vapor phase mol fraction";
    //================================================================================
    //  Files.Connection.matConn inlet[NI](each connNOC = NOC);
    Simulator.Files.Connection.matConn outlet(connNOC = NOC) annotation(
      Placement(visible = true, transformation(origin = {100, -2}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Simulator.Files.Connection.matConn inlet[NI](each connNOC = NOC) annotation(
      Placement(visible = true, transformation(origin = {-100, -2}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    extends Guess_Models.Initial_Guess;
  equation
//Connector equation
    for i in 1:NI loop
      inlet[i].P = inP[i];
      inlet[i].T = inT[i];
      inlet[i].mixMolFlo = inMolFlo[i];
      inlet[i].mixMolEnth = inTotMolEnth[i];
      inlet[i].mixMolEntr = inTotMolEntr[i];
      inlet[i].mixMolFrac[1, :] = inCompMolFrac[i, :];
      inlet[i].vapPhasMolFrac = inVapPhasMolFrac[i];
    end for;
    outlet.P = outP;
    outlet.T = outT;
    outlet.mixMolFlo = outMolFlo;
    outlet.mixMolEnth = outTotMolEnth;
    outlet.mixMolEntr = outTotMolEntr;
    outlet.mixMolFrac[1, :] = outCompMolFrac[:];
    outlet.vapPhasMolFrac = outVapPhasMolFrac;
//===================================================================================
//Output Pressure
    if outPress == "Inlet_Minimum" then
      outP = min(inP);
    elseif outPress == "Inlet_Average" then
      outP = sum(inP) / NI;
    elseif outPress == "Inlet_Maximum" then
      outP = max(inP);
    end if;
//Molar Balance
    outMolFlo = sum(inMolFlo[:]);
    for i in 1:NOC loop
      outCompMolFrac[i] * outMolFlo = sum(inCompMolFrac[:, i] .* inMolFlo[:]);
    end for;
//Energy balance
    outTotMolEnth = sum(inTotMolEnth[:] .* inMolFlo[:] / outMolFlo);
  end Mixer;

  model Heater
    extends Simulator.Files.Icons.Heater;
    // This is generic heater model. For using this model we need to extend this model and incorporte ouput material stream since this model is not doing any flash calculations. Refer heater models in Test section for this.
    //========================================================================================
    Real inMolFlo(start = Feed_flow) "inlet mixture molar flow rate", outMolFlo(start = Feed_flow) "outlet mixture molar flow rate", heatAdd "Heat added", inP(start = Press) "Inlet pressure", outP(start = Press) "Outlet pressure", inT(start = Temp) "Inlet Temperature", outT(start = Temp) "Outlet Temperature", tempInc "Temperature Increase", outVapPhasMolFrac(min = 0, max = 1, start = Beta_guess) "Outlet Vapor Mole Fraction";
    Real inMixMolEnth(start = PhasMolEnth_mix_guess) "inlet mixture molar enthalpy", outMixMolEnth(start = PhasMolEnth_mix_guess) "outlet mixture molar enthalpy";
    //========================================================================================
    parameter Real pressDrop "Pressure drop", eff "Efficiency";
    Real mixMolFrac[NOC](each min = 0, each max = 1, start = CompMolFrac) "mixture mole fraction", inVapPhasMolFrac(min = 0, max = 1, start = Beta_guess) "Inlet vapor phase mole fraction";
    parameter Integer NOC "number of components";
    parameter Simulator.Files.Chemsep_Database.General_Properties comp[NOC];
    //========================================================================================
    Simulator.Files.Connection.matConn inlet(connNOC = NOC) annotation(
      Placement(visible = true, transformation(origin = {-100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Simulator.Files.Connection.matConn outlet(connNOC = NOC) annotation(
      Placement(visible = true, transformation(origin = {100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {100, -2}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Simulator.Files.Connection.enConn energy annotation(
      Placement(visible = true, transformation(origin = {0, -100}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-98, -98}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    //=========================================================================================
    extends Guess_Models.Initial_Guess;
  equation
//connector equations
    inlet.P = inP;
    inlet.T = inT;
    inlet.mixMolFlo = inMolFlo;
    inlet.mixMolEnth = inMixMolEnth;
    inlet.mixMolFrac[1, :] = mixMolFrac[:];
    inlet.vapPhasMolFrac = inVapPhasMolFrac;
    outlet.P = outP;
    outlet.T = outT;
    outlet.mixMolFlo = outMolFlo;
    outlet.mixMolEnth = outMixMolEnth;
    outlet.mixMolFrac[1, :] = mixMolFrac[:];
    outlet.vapPhasMolFrac = outVapPhasMolFrac;
    energy.enFlo = heatAdd;
//=============================================================================================
    inMolFlo = outMolFlo;
//material balance
    inMixMolEnth + eff * heatAdd / inMolFlo = outMixMolEnth;
//energy balance
    inP - pressDrop = outP;
//pressure calculation
    inT + tempInc = outT;
//temperature calculation
  end Heater;

  model Heat_Exchanger
    extends Simulator.Files.Icons.Heat_Exchanger;
    //Heat-Exchanger Operates in various modes
    //Mode-I - Estimation of Hot Fluid Outlet Temperature
    //      Inputs : deltap_hot,deltap_cold,Heat_Loss,coutT,Flow Direction,Name of the calculation type,Area
    //Mode-II - Estimation of Cold Fluid Outlet Temperature
    //      Inputs : deltap_hot,deltap_cold,Heat_Loss,houtT,Flow Direction,Name of the calculation type,Area
    //Mode-III - Estimation of Both the fluid outlet temperature
    //      Inputs : deltap_hot,deltap_cold,Heat_Loss,Qactual,Flow Direction,Name of the calculation type,Area
    //Mode-IV - Estimation of both the fluid outlet temperature-NTU Method
    //      Inputs : deltap_hot,deltap_cold,Heat_Loss,U,Flow Direction,Name of the calculation type,Area
    //Mode-V-Estimation of Heat Transfer Area
    //      Inputs : deltap_hot,deltap_cold,Heat_Loss,U,Flow Direction,Name of the calculation type
    //Mode-VI-Estimation of all parameters given the heat transfer efficiency
    //      Inputs : deltap_hot,deltap_cold,Heat_Loss,U,Efficiency,Flow Direction,Name of the calculation type
    import Simulator.Files.*;
    import Simulator.Files.Thermodynamic_Functions.*;
    parameter Simulator.Files.Chemsep_Database.General_Properties comp[NOC];
    parameter Integer NOC "number of compounds ";
    Simulator.Files.Connection.matConn Hot_In(connNOC = NOC) annotation(
      Placement(visible = true, transformation(origin = {-74, 38}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Simulator.Files.Connection.matConn Hot_Out(connNOC = NOC) annotation(
      Placement(visible = true, transformation(origin = {80, 38}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Simulator.Files.Connection.matConn Cold_In(connNOC = NOC) annotation(
      Placement(visible = true, transformation(origin = {-74, -28}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {0, 100}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Simulator.Files.Connection.matConn Cold_Out(connNOC = NOC) annotation(
      Placement(visible = true, transformation(origin = {76, -30}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {0, -100}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    //Parameters
    //Mode-I -Outlet Temperature-Hot Stream Calculaions
    parameter Real Heat_Loss;
    parameter Real deltap_hot;
    parameter Real deltap_cold;
    parameter String Mode "''CoCurrent'',''CounterCurrent''";
    parameter String Calculation_Method "''BothOutletTemp(UA)''";
    //Variables
    //Hot Stream Inlet
    Real hinP, hinT, hintotMolFlow[1], hinEnth, hinEntr, hincompMolFrac[2, NOC], hinVapfrac;
    //Hot Stream Outlet
    Real houtP, houtT, houttotMolFlow[1], houtEnth, houtEntr, houtcompMolFrac[2, NOC], houtVapfrac;
    //Cold Stream Inlet
    Real cinP, cinT, cintotMolFlow[1], cinEnth, cinEntr, cincompMolFrac[2, NOC], cinVapfrac;
    //Cold Stream Outlet
    Real coutP, coutT, couttT, couttotMolFlow[1], coutEnth, coutEntr, coutcompMolFrac[2, NOC], coutVapfrac;
    Real Qactual(start = 2000) "Actual Heat Load";
    Real Qmax, Qmax_hot, Qmax_cold;
    //Hot Stream Enthalpy at Cold Stream Inlet Temperature
    Real hinCompMolEnth[2, NOC];
    Real hinPhasMolEnth[3];
    //Cold Stream Enthalpy at Hot Stream Inlet Temperature
    Real cinCompMolEnth[2, NOC];
    Real cinPhasMolEnth[3];
    Real deltaH;
    //Heat Exchanger Effeciency
    Real Efficiency;
    //LMTD
    Real delta_T1(start = 20), delta_T2(start = 10);
    Real LMTD "Log Mean Temperature Difference";
    //Global Heat Transfer Coefficient
    Real U;
    //Heat Transfer Area
    Real Area;
    //==================================================================================================================
    //Mode-4-NTU Method-when both the outlet temperatures are unknown
    //Heat Capacity Rate for hot and cold fluid
    Real C_cold, C_hot;
    //Number of Transfer Units for Hot Side and Cold Side
    Real NTU_cold, NTU_hot;
    //Heat Capacity Ratio for hot and cold side
    Real R_cold, R_hot;
    //Effectiveness Factor
    Real Eff_cold, Eff_hot;
  equation
//Hot Stream Inlet
    Hot_In.P = hinP;
    Hot_In.T = hinT;
    Hot_In.mixMolFlo = hintotMolFlow[1];
    Hot_In.mixMolEnth = hinEnth;
    Hot_In.mixMolEntr = hinEntr;
    Hot_In.mixMolFrac[1, :] = hincompMolFrac[1, :];
    Hot_In.mixMolFrac[2, :] = hincompMolFrac[2, :];
    Hot_In.vapPhasMolFrac = hinVapfrac;
//Hot Stream Outlet
    Hot_Out.P = houtP;
    Hot_Out.T = houtT;
    Hot_Out.mixMolFlo = houttotMolFlow[1];
    Hot_Out.mixMolEnth = houtEnth;
    Hot_Out.mixMolEntr = houtEntr;
    Hot_Out.mixMolFrac[1, :] = houtcompMolFrac[1, :];
    Hot_Out.mixMolFrac[2, :] = houtcompMolFrac[2, :];
    Hot_Out.vapPhasMolFrac = houtVapfrac;
//Cold Stream In
    Cold_In.P = cinP;
    Cold_In.T = cinT;
    Cold_In.mixMolFlo = cintotMolFlow[1];
    Cold_In.mixMolEnth = cinEnth;
    Cold_In.mixMolEntr = cinEntr;
    Cold_In.mixMolFrac[1, :] = cincompMolFrac[1, :];
    Cold_In.mixMolFrac[2, :] = cincompMolFrac[2, :];
    Cold_In.vapPhasMolFrac = cinVapfrac;
//Cold Stream Out
    Cold_Out.P = coutP;
    Cold_Out.T = couttT;
    Cold_Out.mixMolFlo = couttotMolFlow[1];
    Cold_Out.mixMolEnth = coutEnth;
    Cold_Out.mixMolEntr = coutEntr;
    Cold_Out.mixMolFrac[1, :] = coutcompMolFrac[1, :];
    Cold_Out.mixMolFrac[2, :] = coutcompMolFrac[2, :];
    Cold_Out.vapPhasMolFrac = coutVapfrac;
  equation
    hintotMolFlow[1] = houttotMolFlow[1];
    cintotMolFlow[1] = couttotMolFlow[1];
    hincompMolFrac[1] = houtcompMolFrac[1];
    cincompMolFrac[1] = coutcompMolFrac[1];
    houtP = hinP - deltap_hot;
    coutP = cinP - deltap_cold;
    Qactual = cintotMolFlow[1] * (coutEnth - cinEnth);
    deltaH = -(Qactual + Heat_Loss * 1000) / hintotMolFlow[1];
    if Calculation_Method == "BothOutletTemp(UA)" then
      houtEnth = hinEnth - Qactual / hintotMolFlow[1] - Heat_Loss * 1000 / hintotMolFlow[1];
      coutT = cinT + Eff_cold * (hinT - cinT);
    else
      coutT = couttT;
      houtEnth = hinEnth + deltaH;
    end if;
//==========================================================================================================
//Calculation of Hot Stream Enthalpy at  Cold Stream Inlet Temperature
    for i in 1:NOC loop
      hinCompMolEnth[1, i] = Thermodynamic_Functions.HLiqId(comp[i].SH, comp[i].VapCp, comp[i].HOV, comp[i].Tc, cinT);
      hinCompMolEnth[2, i] = Thermodynamic_Functions.HVapId(comp[i].SH, comp[i].VapCp, comp[i].HOV, comp[i].Tc, cinT);
    end for;
    for i in 1:2 loop
      hinPhasMolEnth[i] = sum(hincompMolFrac[i, :] .* hinCompMolEnth[i, :]);
/*+ inResMolEnth[2, i]*/
    end for;
    hinPhasMolEnth[3] = (1 - hinVapfrac) * hinPhasMolEnth[1] + hinVapfrac * hinPhasMolEnth[2];
//Maximum Theoritical Heat Exchange-Hot Fluid
    Qmax_hot = hintotMolFlow[1] * (hinEnth - hinPhasMolEnth[3]);
//===========================================================================================================
//Enthalpy of Cold Stream Enthalpy at Hot Fluid Inlet Temperature
    for i in 1:NOC loop
      cinCompMolEnth[1, i] = Thermodynamic_Functions.HLiqId(comp[i].SH, comp[i].VapCp, comp[i].HOV, comp[i].Tc, hinT);
      cinCompMolEnth[2, i] = Thermodynamic_Functions.HVapId(comp[i].SH, comp[i].VapCp, comp[i].HOV, comp[i].Tc, hinT);
    end for;
    for i in 1:2 loop
      cinPhasMolEnth[i] = sum(cincompMolFrac[i, :] .* cinCompMolEnth[i, :]);
/*+ inResMolEnth[1, i]*/
    end for;
    cinPhasMolEnth[3] = (1 - cinVapfrac) * cinPhasMolEnth[1] + cinVapfrac * cinPhasMolEnth[2];
//Maximum Theoritical Heat Exchange- Cold Fluid
    Qmax_cold = cintotMolFlow[1] * abs(cinEnth - cinPhasMolEnth[3]);
//Maximum Heat Exchange
    Qmax = min(Qmax_hot, Qmax_cold);
    Efficiency = (Qactual - Heat_Loss * 1000) / Qmax * 100;
//Log Mean Temperature Difference
    if Mode == "CoCurrent" then
      delta_T1 = hinT - cinT;
      delta_T2 = houtT - coutT;
    elseif Mode == "CounterCurrent" then
      delta_T1 = hinT - coutT;
      delta_T2 = houtT - cinT;
    end if;
    if delta_T1 <= 0 or delta_T2 <= 0 then
      LMTD = 1;
    else
      LMTD = (delta_T1 - delta_T2) / log(delta_T1 / delta_T2);
    end if;
    U = Qactual / (Area * LMTD);
//===========================================================================================================
//==========================================================================================================
//NTU-Method
    C_cold = cintotMolFlow[1] * ((coutEnth - cinEnth) / (coutT - cinT));
    C_hot = hintotMolFlow[1] * ((houtEnth - hinEnth) / (houtT - hinT));
//Number of Transfer Units
    NTU_cold = U * Area / C_cold;
    NTU_hot = U * Area / C_hot;
//Heat Capacity Ratio for Hot and Cold Side
    R_cold = C_cold / C_hot;
    R_hot = C_hot / C_cold;
    if Mode == "CoCurrent" then
      Eff_cold = (1 - exp(-NTU_cold * (1 + R_cold))) / (1 + R_cold);
      Eff_hot = (1 - exp(-NTU_hot * (1 + R_hot))) / (1 + R_hot);
    elseif Mode == "CounterCurrent" then
      Eff_cold = (1 - exp((R_cold - 1) * NTU_cold)) / (1 - R_cold * exp((R_cold - 1) * NTU_cold));
      Eff_hot = (1 - exp((R_hot - 1) * NTU_hot)) / (1 - R_hot * exp((R_hot - 1) * NTU_hot));
    end if;
  end Heat_Exchanger;

  model Cooler
    extends Simulator.Files.Icons.Cooler;
    // This is generic cooler model. For using this model we need to extend this model and incorporte ouput material stream since this model is not doing any flash calculations. Refer cooler models in Test section for this.
    //====================================================================================
    Real inMolFlo(start = Feed_flow) "inlet mixture molar flow rate", outMolFlo(start = Feed_flow) "outlet mixture molar flow rate", heatRem "Heat removed", inP(start = Press) "Inlet pressure", outP(min = 0, start = 101325) "Outlet pressure", inT(start = Temp) "Inlet Temperature", outT(start = Temp) "Outlet Temperature", tempDrop "Temperature Drop", outVapPhasMolFrac(min = 0, max = 1, start = Beta_guess) "Outlet Vapor Mole Fraction";
    Real inMixMolEnth(start = PhasMolEnth_mix_guess) "inlet mixture molar enthalpy", outMixMolEnth(start = PhasMolEnth_mix_guess) "outlet mixture molar enthalpy";
    Real inMixMolEntr "inlet mixture molar entropy", outMixMolEntr "outlet mixture molar entropy", mixMolFrac[NOC](each min = 0, each max = 1, start = CompMolFrac) "mixture mole fraction", inVapPhasMolFrac(min = 0, max = 1, start = Beta_guess) "Inlet vapor phase mole fraction";
    //========================================================================================
    parameter Real pressDrop "Pressure drop", eff "Efficiency";
    parameter Integer NOC "number of components";
    parameter Simulator.Files.Chemsep_Database.General_Properties comp[NOC];
    //========================================================================================
    Files.Connection.matConn inlet(connNOC = NOC) annotation(
      Placement(visible = true, transformation(origin = {-100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Simulator.Files.Connection.matConn outlet(connNOC = NOC) annotation(
      Placement(visible = true, transformation(origin = {100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Simulator.Files.Connection.enConn energy annotation(
      Placement(visible = true, transformation(origin = {0, -100}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {100, -100}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    //========================================================================================
    extends Guess_Models.Initial_Guess;
  equation
//connector equations
    inlet.P = inP;
    inlet.T = inT;
    inlet.mixMolFlo = inMolFlo;
    inlet.mixMolEnth = inMixMolEnth;
    inlet.mixMolEntr = inMixMolEntr;
    inlet.mixMolFrac[1, :] = mixMolFrac[:];
    inlet.vapPhasMolFrac = inVapPhasMolFrac;
    outlet.P = outP;
    outlet.T = outT;
    outlet.mixMolFlo = outMolFlo;
    outlet.mixMolEnth = outMixMolEnth;
    outlet.mixMolEntr = outMixMolEntr;
    outlet.mixMolFrac[1, :] = mixMolFrac[:];
    outlet.vapPhasMolFrac = outVapPhasMolFrac;
    energy.enFlo = heatRem;
//=============================================================================================
    inMolFlo = outMolFlo;
//material balance
    inMixMolEnth - eff * heatRem / inMolFlo = outMixMolEnth;
//energy balance
    inP - pressDrop = outP;
//pressure calculation
    inT - tempDrop = outT;
//temperature calculation
  end Cooler;

  model Valve
    extends Simulator.Files.Icons.Valve;
    // This is generic valve model. For using this model we need to extend this model and incorporte ouput material stream since this model is not doing any flash calculations. Refer valve model in Test section for this.
    //====================================================================================
    Real inMolFlo(start = Feed_flow) "inlet mixture molar flow rate", outMolFlo(start = Feed_flow) "outlet mixture molar flow rate", inP(start = Press) "Inlet pressure", outP(start = Press) "Outlet pressure", pressDrop "Pressure drop", inT(start = Temp) "Inlet Temperature", outT(start = Temp) "Outlet Temperature", tempInc "Temperature Increase";
    Real inMixMolEnth(start = PhasMolEnth_mix_guess) "inlet mixture molar enthalpy", outMixMolEnth(PhasMolEnth_mix_guess) "outlet mixture molar enthalpy";
    Real inMixMolEntr "inlet mixture molar entropy", outMixMolEntr "outlet mixture molar entropy", mixMolFrac[NOC](each min = 0, each max = 1, start = CompMolFrac) "mixture mole fraction", inVapPhasMolFrac(min = 0, max = 1, start = Beta_guess) "Inlet vapor phase mole fraction", outVapPhasMolFrac(min = 0, max = 1, start = Beta_guess) "Outlet vapor phase mole fraction";
    //========================================================================================
    parameter Integer NOC = 3 "number of components";
    parameter Simulator.Files.Chemsep_Database.General_Properties comp[NOC];
    extends Guess_Models.Initial_Guess;
    //========================================================================================
    Files.Connection.matConn inlet(connNOC = NOC) annotation(
      Placement(visible = true, transformation(origin = {-100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Simulator.Files.Connection.matConn outlet(connNOC = NOC) annotation(
      Placement(visible = true, transformation(origin = {100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    //========================================================================================
  equation
//connector equations
    inlet.P = inP;
    inlet.T = inT;
    inlet.mixMolFlo = inMolFlo;
    inlet.mixMolEnth = inMixMolEnth;
    inlet.mixMolEntr = inMixMolEntr;
    inlet.mixMolFrac[1, :] = mixMolFrac[:];
    inlet.vapPhasMolFrac = inVapPhasMolFrac;
    outlet.P = outP;
    outlet.T = outT;
    outlet.mixMolFlo = outMolFlo;
    outlet.mixMolEnth = outMixMolEnth;
    outlet.mixMolEntr = outMixMolEntr;
    outlet.mixMolFrac[1, :] = mixMolFrac[:];
    outlet.vapPhasMolFrac = outVapPhasMolFrac;
//=============================================================================================
    inMolFlo = outMolFlo;
//material balance
    inMixMolEnth = outMixMolEnth;
//energy balance
    inP - pressDrop = outP;
//pressure calculation
    inT + tempInc = outT;
//temperature calculation
  end Valve;

  model Shortcut_Column
    extends Simulator.Files.Icons.Distillation_Column;
    import data = Simulator.Files.Chemsep_Database;
    parameter data.General_Properties comp[NOC];
    parameter Integer NOC;
    Real mixMolFlo[3](each min = 0, s), mixMolFrac[3, NOC](each start = 1 / (NOC + 1), each min = 0, each max = 1), mixMolEnth[3], mixMolEntr[3];
    Real minN(min = 0, start = 10), minR(start = 1);
    Real alpha[NOC], theta(start = 1);
    Real P(min = 0, start = 101325), T(min = 0, start = 273.15);
    Real condT(start = max(comp[:].Tb), min = 0), condP(min = 0, start = 101325), rebP(min = 0, start = 101325), rebT(start = min(comp[:].Tb), min = 0);
    parameter Integer HKey, LKey;
    parameter String condType = "Total";
    Real vapPhasMolFrac[3](each min = 0, each max = 1, each start = 0.5), condLiqMixMolEnth, condVapMixMolEnth, condVapCompMolEnth[NOC], condLiqCompMolEnth[NOC], condLiqMolFrac[NOC](each min = 0, each max = 1, each start = 1 / (NOC + 1)), condVapMolFrac[NOC](each min = 0, each max = 1, each start = 1 / (NOC + 1));
    Real compMolFrac[3, NOC](each min = 0, each max = 1, each start = 1 / (NOC + 1)), Pdew(min = 0, start = sum(comp[:].Pc) / NOC), Pbubl(min = 0, start = sum(comp[:].Pc) / NOC);
    Real actR, actN, x, y, feedN;
    Real rectLiq(min = 0, start = 100), rectVap(min = 0, start = 100), stripLiq(min = 0, start = 100), stripVap(min = 0, start = 100), rebDuty, condDuty;
    Simulator.Files.Connection.matConn feed(connNOC = NOC) annotation(
      Placement(visible = true, transformation(origin = {-250, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-250, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Simulator.Files.Connection.matConn distillate(connNOC = NOC) annotation(
      Placement(visible = true, transformation(origin = {250, 336}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {250, 300}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Simulator.Files.Connection.matConn bottoms(connNOC = NOC) annotation(
      Placement(visible = true, transformation(origin = {250, -266}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {250, -300}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Simulator.Files.Connection.enConn condenser_duty annotation(
      Placement(visible = true, transformation(origin = {248, 594}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {250, 600}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Simulator.Files.Connection.enConn reboiler_duty annotation(
      Placement(visible = true, transformation(origin = {254, -592}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {250, -600}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  equation
// Connector equations
    feed.P = P;
    feed.T = T;
    feed.mixMolFlo = mixMolFlo[1];
    feed.mixMolFrac[1, :] = mixMolFrac[1, :];
    feed.mixMolEnth = mixMolEnth[1];
    feed.mixMolEntr = mixMolEntr[1];
    feed.vapPhasMolFrac = vapPhasMolFrac[1];
    bottoms.P = rebP;
    bottoms.T = rebT;
    bottoms.mixMolFlo = mixMolFlo[2];
    bottoms.mixMolFrac[1, :] = mixMolFrac[2, :];
    bottoms.mixMolEnth = mixMolEnth[2];
    bottoms.mixMolEntr = mixMolEntr[2];
    bottoms.vapPhasMolFrac = vapPhasMolFrac[2];
    distillate.P = condP;
    distillate.T = condT;
    distillate.mixMolFlo = mixMolFlo[3];
    distillate.mixMolFrac[1, :] = mixMolFrac[3, :];
    distillate.mixMolEnth = mixMolEnth[3];
    distillate.mixMolEntr = mixMolEntr[3];
    distillate.vapPhasMolFrac = vapPhasMolFrac[3];
    reboiler_duty.enFlo = rebDuty;
    condenser_duty.enFlo = condDuty;
//adjustment for thermodynamic packages
    compMolFrac[1, :] = mixMolFrac[1, :];
    compMolFrac[2, :] = compMolFrac[1, :] ./ (1 .+ vapPhasMolFrac[1] .* (K[:] .- 1));
    for i in 1:NOC loop
      compMolFrac[3, i] = K[i] * compMolFrac[2, i];
    end for;
//  sum(compMolFrac[1,:] .* (K[:] .- 1) ./ (1 .+ vapPhasMolFrac[1] .* (K[:] .- 1))) = 0;
//Bubble point calculation
    Pbubl = sum(gammaBubl[:] .* compMolFrac[1, :] .* exp(comp[:].VP[2] + comp[:].VP[3] / T + comp[:].VP[4] * log(T) + comp[:].VP[5] .* T .^ comp[:].VP[6]) ./ liqfugcoeff_bubl[:]);
//Dew point calculation
    Pdew = 1 / sum(compMolFrac[1, :] ./ (gammaDew[:] .* exp(comp[:].VP[2] + comp[:].VP[3] / T + comp[:].VP[4] * log(T) + comp[:].VP[5] .* T .^ comp[:].VP[6])) .* vapfugcoeff_dew[:]);
  equation
    for i in 1:NOC loop
      if mixMolFrac[1, i] == 0 then
        mixMolFrac[3, i] = 0;
      else
        mixMolFlo[1] .* mixMolFrac[1, i] = mixMolFlo[2] .* mixMolFrac[2, i] + mixMolFlo[3] .* mixMolFrac[3, i];
      end if;
    end for;
    sum(mixMolFrac[3, :]) = 1;
    sum(mixMolFrac[2, :]) = 1;
    for i in 1:NOC loop
      if i <> HKey then
        if condType == "Total" then
          mixMolFrac[3, i] / mixMolFrac[3, HKey] = alpha[i] ^ minN * (mixMolFrac[2, i] / mixMolFrac[2, HKey]);
        elseif condType == "Partial" then
          mixMolFrac[3, i] / mixMolFrac[3, HKey] = alpha[i] ^ (minN + 1) * (mixMolFrac[2, i] / mixMolFrac[2, HKey]);
        end if;
      end if;
    end for;
    alpha[:] = K[:] / K[HKey];
//Calculation of temperature at distillate and bottoms
    if condT <= 0 and rebT <= 0 then
      if condType == "Partial" then
        1 / condP = sum(mixMolFrac[3, :] ./ (gamma[:] .* exp(comp[:].VP[2] + comp[:].VP[3] / 1 + comp[:].VP[4] * 1 + comp[:].VP[5] .* condT .^ comp[:].VP[6])));
        rebP = sum(gamma[:] .* mixMolFrac[2, :] .* exp(comp[:].VP[2] + comp[:].VP[3] / 1 + comp[:].VP[4] * 1 + comp[:].VP[5] .* rebT .^ comp[:].VP[6]));
      elseif condType == "Total" then
        condP = sum(gamma[:] .* mixMolFrac[3, :] .* exp(comp[:].VP[2] + comp[:].VP[3] / 1 + comp[:].VP[4] * 1 + comp[:].VP[5] .* condT .^ comp[:].VP[6]));
        rebP = sum(gamma[:] .* mixMolFrac[2, :] .* exp(comp[:].VP[2] + comp[:].VP[3] / 1 + comp[:].VP[4] * 1 + comp[:].VP[5] .* rebT .^ comp[:].VP[6]));
      end if;
    elseif condT <= 0 then
      if condType == "Partial" then
        1 / condP = sum(mixMolFrac[3, :] ./ (gamma[:] .* exp(comp[:].VP[2] + comp[:].VP[3] / 1 + comp[:].VP[4] * 1 + comp[:].VP[5] .* condT .^ comp[:].VP[6])));
        rebP = sum(gamma[:] .* mixMolFrac[2, :] .* exp(comp[:].VP[2] + comp[:].VP[3] / rebT + comp[:].VP[4] * log(rebT) + comp[:].VP[5] .* rebT .^ comp[:].VP[6]));
      elseif condType == "Total" then
        condP = sum(gamma[:] .* mixMolFrac[3, :] .* exp(comp[:].VP[2] + comp[:].VP[3] / 1 + comp[:].VP[4] * 1 + comp[:].VP[5] .* condT .^ comp[:].VP[6]));
        rebP = sum(gamma[:] .* mixMolFrac[2, :] .* exp(comp[:].VP[2] + comp[:].VP[3] / rebT + comp[:].VP[4] * log(rebT) + comp[:].VP[5] .* rebT .^ comp[:].VP[6]));
      end if;
    elseif rebT <= 0 then
      if condType == "Partial" then
        1 / condP = sum(mixMolFrac[3, :] ./ (gamma[:] .* exp(comp[:].VP[2] + comp[:].VP[3] / condT + comp[:].VP[4] * log(condT) + comp[:].VP[5] .* condT .^ comp[:].VP[6])));
        rebP = sum(gamma[:] .* mixMolFrac[2, :] .* exp(comp[:].VP[2] + comp[:].VP[3] / 1 + comp[:].VP[4] * 1 + comp[:].VP[5] .* rebT .^ comp[:].VP[6]));
      elseif condType == "Total" then
        condP = sum(gamma[:] .* mixMolFrac[3, :] .* exp(comp[:].VP[2] + comp[:].VP[3] / condT + comp[:].VP[4] * log(condT) + comp[:].VP[5] .* condT .^ comp[:].VP[6]));
        rebP = sum(gamma[:] .* mixMolFrac[2, :] .* exp(comp[:].VP[2] + comp[:].VP[3] / 1 + comp[:].VP[4] * 1 + comp[:].VP[5] .* rebT .^ comp[:].VP[6]));
      end if;
    else
      if condType == "Partial" then
        1 / condP = sum(mixMolFrac[3, :] ./ (gamma[:] .* exp(comp[:].VP[2] + comp[:].VP[3] / condT + comp[:].VP[4] * log(condT) + comp[:].VP[5] .* condT .^ comp[:].VP[6])));
        rebP = sum(gamma[:] .* mixMolFrac[2, :] .* exp(comp[:].VP[2] + comp[:].VP[3] / rebT + comp[:].VP[4] * log(rebT) + comp[:].VP[5] .* rebT .^ comp[:].VP[6]));
      elseif condType == "Total" then
        condP = sum(gamma[:] .* mixMolFrac[3, :] .* exp(comp[:].VP[2] + comp[:].VP[3] / condT + comp[:].VP[4] * log(condT) + comp[:].VP[5] .* condT .^ comp[:].VP[6]));
        rebP = sum(gamma[:] .* mixMolFrac[2, :] .* exp(comp[:].VP[2] + comp[:].VP[3] / rebT + comp[:].VP[4] * log(rebT) + comp[:].VP[5] .* rebT .^ comp[:].VP[6]));
      end if;
    end if;
//Minimum Reflux, Underwoods method
    if theta > alpha[LKey] or theta < alpha[HKey] then
      0 = sum(alpha[:] .* mixMolFrac[1, :] ./ (alpha[:] .- theta));
//This is mathamatical adjustment for right convergence of theta
    else
      vapPhasMolFrac[1] = sum(alpha[:] .* mixMolFrac[1, :] ./ (alpha[:] .- theta));
    end if;
    minR + 1 = sum(alpha[:] .* mixMolFrac[3, :] ./ (alpha[:] .- theta));
//Actual number of trays,Gillilands method
    x = (actR - minR) / (actR + 1);
    y = (actN - minN) / (actN + 1);
    if x >= 0 then
      y = 0.75 * (1 - x ^ 0.5668);
    else
      y = -1;
    end if;
// Feed location, Fenske equation
    feedN = actN / minN * log(mixMolFrac[1, LKey] / mixMolFrac[1, HKey] * (mixMolFrac[2, HKey] / mixMolFrac[2, LKey])) / log(K[LKey] / K[HKey]);
//rectifying and stripping flows
    rectLiq = actR * mixMolFlo[3];
    stripLiq = (1 - vapPhasMolFrac[1]) * mixMolFlo[1] + rectLiq;
    stripVap = stripLiq - mixMolFlo[2];
    rectVap = vapPhasMolFrac[1] * mixMolFlo[1] + stripVap;
    for i in 1:NOC loop
      condVapCompMolEnth[i] = Simulator.Files.Thermodynamic_Functions.HVapId(comp[i].SH, comp[i].VapCp, comp[i].HOV, comp[i].Tc, condT);
      condLiqCompMolEnth[i] = Simulator.Files.Thermodynamic_Functions.HLiqId(comp[i].SH, comp[i].VapCp, comp[i].HOV, comp[i].Tc, condT);
    end for;
    if condType == "Total" then
      condLiqMixMolEnth = mixMolEnth[3];
    elseif condType == "Partial" then
      condLiqMixMolEnth = sum(condLiqMolFrac[:] .* condLiqCompMolEnth[:]);
    end if;
    condVapMixMolEnth = sum(condVapMolFrac[:] .* condVapCompMolEnth[:]);
    rectVap .* condVapMolFrac[:] = rectLiq .* condLiqMolFrac[:] + mixMolFlo[3] .* mixMolFrac[3, :];
    if condType == "Partial" then
      mixMolFrac[3, :] = K[:] .* condLiqMolFrac[:];
    elseif condType == "Total" then
      mixMolFrac[3, :] = condLiqMolFrac[:];
    end if;
//Energy Balance
    mixMolFlo[1] * mixMolEnth[1] + rebDuty - condDuty = mixMolFlo[2] * mixMolEnth[2] + mixMolFlo[3] * mixMolEnth[3];
    rectVap * condVapMixMolEnth = condDuty + mixMolFlo[3] * mixMolEnth[3] + rectLiq * condLiqMixMolEnth;
    annotation(
      Icon(coordinateSystem(extent = {{-250, -600}, {250, 600}})),
      Diagram(coordinateSystem(extent = {{-250, -600}, {250, 600}})),
      __OpenModelica_commandLineOptions = "");
  end Shortcut_Column;

  model Compound_Separator
    extends Simulator.Files.Icons.Compound_Separator;
    parameter Integer NOC "Number of components", sepStrm "Specified Stream";
    parameter Simulator.Files.Chemsep_Database.General_Properties comp[NOC] "Components array";
    Real inP(start = Press) "inlet pressure", inT(start = Temp) "inlet temperature", inMixMolFrac[NOC](each min = 0, each max = 1, start = CompMolFrac) "inlet mixture mole fraction", inMixMolFlo(start = Feed_flow) "inlet mixture molar flow", inCompMolFlo[NOC](each min = 0, each start = Feed_flow) "inlet compound molar flow", inCompMasFlo[NOC](each min = 0, each start = Feed_flow) "inlet compound mass flow", inMixMolEnth(start = PhasMolEnth_mix_guess) "inlet mixture molar enthalpy";
    Real outP[2](each min = 0, start = {Press, Press}) "outlet Pressure", outT[2](each min = 0, start = {Temp, Temp}) "outlet temperature", outMixMolFrac[2, NOC](each min = 0, each max = 1, start = CompMolFrac) "outlet mixture mole fraction", outMixMolFlo[2](each min = 0, each start = Feed_flow) "Outlet mixture molar flow", outCompMolFlo[2, NOC](each min = 0, each start = Feed_flow) "outlet compounds molar flow", outCompMasFlo[2, NOC](each min = 0, each start = Feed_flow) "outlet compound mass flow", outMixMolEnth[2] "outlet mixture molar enthalpy";
    Real enReq "energy required";
    Real sepFactVal[NOC] "Separation factor value";
    parameter String sepFact[NOC] "Separation factor";
    // separation factor: Molar_Flow, Mass_Flow, Inlet_Molar_Flow_Percent, Inlet_Mass_Flow_Percent.
    Simulator.Files.Connection.matConn inlet(connNOC = NOC) annotation(
      Placement(visible = true, transformation(origin = {-100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Simulator.Files.Connection.matConn outlet1(connNOC = NOC) annotation(
      Placement(visible = true, transformation(origin = {100, 70}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {100, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Simulator.Files.Connection.enConn energy annotation(
      Placement(visible = true, transformation(origin = {0, -100}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {0, -130}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Simulator.Files.Connection.matConn outlet2(connNOC = NOC) annotation(
      Placement(visible = true, transformation(origin = {100, -70}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {100, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    extends Guess_Models.Initial_Guess;
  equation
// Connector equation
    inlet.P = inP;
    inlet.T = inT;
    inlet.mixMolFlo = inMixMolFlo;
    inlet.mixMolFrac[1, :] = inMixMolFrac[:];
    inlet.mixMolEnth = inMixMolEnth;
    outlet1.P = outP[1];
    outlet1.T = outT[1];
    outlet1.mixMolFlo = outMixMolFlo[1];
    outlet1.mixMolFrac[1, :] = outMixMolFrac[1, :];
    outlet1.mixMolEnth = outMixMolEnth[1];
    outlet2.mixMolFlo = outMixMolFlo[2];
    outlet2.mixMolFrac[1, :] = outMixMolFrac[2, :];
    outlet2.mixMolEnth = outMixMolEnth[2];
    outlet2.P = outP[2];
    outlet2.T = outT[2];
    energy.enFlo = enReq;
// Pressure and temperature equations
    outP[1] = inP;
    outP[2] = inP;
    outT[1] = inT;
    outT[2] = inT;
// mole balance
    inMixMolFlo = sum(outMixMolFlo[:]);
    inCompMolFlo[:] = outMixMolFrac[1, :] * outMixMolFlo[1] + outMixMolFrac[2, :] * outMixMolFlo[2];
// Conversion
    inCompMolFlo = inMixMolFrac .* inMixMolFlo;
    inCompMasFlo = inCompMolFlo .* comp[:].MW;
    for i in 1:2 loop
      outCompMolFlo[i, :] = outMixMolFrac[i, :] .* outMixMolFlo[i];
      outCompMasFlo[i, :] = outCompMolFlo[i, :] .* comp[:].MW;
    end for;
    sum(outMixMolFrac[2, :]) = 1;
    for i in 1:NOC loop
      if sepFact[i] == "Molar_Flow" then
        sepFactVal[i] = outCompMolFlo[sepStrm, i];
      elseif sepFact[i] == "Mass_Flow" then
        sepFactVal[i] = outCompMasFlo[sepStrm, i];
      elseif sepFact[i] == "Inlet_Molar_Flow_Percent" then
        outCompMolFlo[sepStrm, i] = sepFactVal[i] * inCompMolFlo[i] / 100;
      elseif sepFact[i] == "Inlet_Mass_Flow_Percent" then
        outCompMasFlo[sepStrm, i] = sepFactVal[i] * inCompMasFlo[i] / 100;
      end if;
    end for;
//Energy balance
    enReq = sum(outMixMolEnth .* outMixMolFlo) - inMixMolFlo * inMixMolEnth;
    annotation(
      Icon(coordinateSystem(extent = {{-100, -200}, {100, 200}})),
      Diagram(coordinateSystem(extent = {{-100, -200}, {100, 200}})),
      __OpenModelica_commandLineOptions = "");
  end Compound_Separator;

  model Flash
    extends Simulator.Files.Icons.Flash;
    //extend thermodynamic package with this model
    import Simulator.Files.*;
    parameter Integer NOC;
    parameter Chemsep_Database.General_Properties comp[NOC];
    parameter Boolean overSepTemp = false, overSepPress = false;
    parameter Real Tdef = 298.15, Pdef = 101325;
    Real T(start = Temp), P(start = Press);
    Real Pbubl(start = Pmin) "Bubble point pressure", Pdew(start = Pmax) "dew point pressure";
    Real totMolFlo[3](each min = 0, start = {Feed_flow, Liquid_flow, Vapour_flow}), compMolFrac[3, NOC](each min = 0, each max = 1, start = {CompMolFrac, CompMolFrac, CompMolFrac}), compMolSpHeat[3, NOC], compMolEnth[3, NOC], compMolEntr[3, NOC], phasMolSpHeat[3], phasMolEnth[3], phasMolEntr[3], liqPhasMolFrac(min = 0, max = 1, start = Alpha_guess), vapPhasMolFrac(min = 0, max = 1, start = Beta_guess);
    Simulator.Files.Connection.matConn feed(connNOC = NOC) annotation(
      Placement(visible = true, transformation(origin = {-100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Simulator.Files.Connection.matConn vapor(connNOC = NOC) annotation(
      Placement(visible = true, transformation(origin = {102, 72}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {100, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Simulator.Files.Connection.matConn liquid(connNOC = NOC) annotation(
      Placement(visible = true, transformation(origin = {100, -72}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {100, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    extends Guess_Models.Initial_Guess;
  equation
//Connector equation
    if overSepTemp then
      Tdef = T;
    else
      feed.T = T;
    end if;
    if overSepPress then
      Pdef = P;
    else
      feed.P = P;
    end if;
    feed.mixMolFlo = totMolFlo[1];
    feed.mixMolFrac[1, :] = compMolFrac[1, :];
    liquid.T = T;
//  liquid.mixMolEnth = phasMolEnth[2];
    liquid.P = P;
    liquid.mixMolFlo = totMolFlo[2];
    liquid.mixMolFrac[1, :] = compMolFrac[2, :];
    vapor.T = T;
//  vapor.mixMolEnth= phasMolEnth[3];
    vapor.P = P;
    vapor.mixMolFlo = totMolFlo[3];
    vapor.mixMolFrac[1, :] = compMolFrac[3, :];
//Mole Balance
    totMolFlo[1] = totMolFlo[2] + totMolFlo[3];
    compMolFrac[1, :] .* totMolFlo[1] = compMolFrac[2, :] .* totMolFlo[2] + compMolFrac[3, :] .* totMolFlo[3];
//Bubble point calculation
    Pbubl = sum(gammaBubl[:] .* compMolFrac[1, :] .* exp(comp[:].VP[2] + comp[:].VP[3] / T + comp[:].VP[4] * log(T) + comp[:].VP[5] .* T .^ comp[:].VP[6]) ./ liqfugcoeff_bubl[:]);
//Dew point calculation
    Pdew = 1 / sum(compMolFrac[1, :] ./ (gammaDew[:] .* exp(comp[:].VP[2] + comp[:].VP[3] / T + comp[:].VP[4] * log(T) + comp[:].VP[5] .* T .^ comp[:].VP[6])) .* vapfugcoeff_dew[:]);
    if P >= Pbubl then
      compMolFrac[3, :] = zeros(NOC);
//    sum(compMolFrac[2, :]) = 1;
      totMolFlo[3] = 0;
    elseif P >= Pdew then
//VLE region
      for i in 1:NOC loop
//      compMolFrac[3, i] = K[i] * compMolFrac[2, i];
        compMolFrac[2, i] = compMolFrac[1, i] ./ (1 + vapPhasMolFrac * (K[i] - 1));
      end for;
//    sum(compMolFrac[3, :]) = 1;
      sum(compMolFrac[2, :]) = 1;
//sum x = 1
    else
//above dew point region
      compMolFrac[2, :] = zeros(NOC);
//    sum(compMolFrac[3, :]) = 1;
      totMolFlo[2] = 0;
    end if;
//Energy Balance
    for i in 1:NOC loop
//Specific Heat and Enthalpy calculation
      compMolSpHeat[2, i] = Thermodynamic_Functions.LiqCpId(comp[i].LiqCp, T);
      compMolSpHeat[3, i] = Thermodynamic_Functions.VapCpId(comp[i].VapCp, T);
      compMolEnth[2, i] = Thermodynamic_Functions.HLiqId(comp[i].SH, comp[i].VapCp, comp[i].HOV, comp[i].Tc, T);
      compMolEnth[3, i] = Thermodynamic_Functions.HVapId(comp[i].SH, comp[i].VapCp, comp[i].HOV, comp[i].Tc, T);
      (compMolEntr[2, i], compMolEntr[3, i]) = Thermodynamic_Functions.SId(comp[i].AS, comp[i].VapCp, comp[i].HOV, comp[i].Tb, comp[i].Tc, T, P, compMolFrac[2, i], compMolFrac[3, i]);
    end for;
    for i in 2:3 loop
      phasMolSpHeat[i] = sum(compMolFrac[i, :] .* compMolSpHeat[i, :]) + resMolSpHeat[i];
      phasMolEnth[i] = sum(compMolFrac[i, :] .* compMolEnth[i, :]) + resMolEnth[i];
      phasMolEntr[i] = sum(compMolFrac[i, :] .* compMolEntr[i, :]) + resMolEntr[i];
    end for;
    phasMolSpHeat[1] = liqPhasMolFrac * phasMolSpHeat[2] + vapPhasMolFrac * phasMolSpHeat[3];
    compMolSpHeat[1, :] = compMolFrac[1, :] .* phasMolSpHeat[1];
    phasMolEnth[1] = liqPhasMolFrac * phasMolEnth[2] + vapPhasMolFrac * phasMolEnth[3];
    compMolEnth[1, :] = compMolFrac[1, :] .* phasMolEnth[1];
    phasMolEntr[1] = liqPhasMolFrac * phasMolEntr[2] + vapPhasMolFrac * phasMolEntr[3];
    compMolEntr[1, :] = compMolFrac[1, :] * phasMolEntr[1];
//phase molar fractions
    liqPhasMolFrac = totMolFlo[2] / totMolFlo[1];
    vapPhasMolFrac = totMolFlo[3] / totMolFlo[1];
    annotation(
      Icon(coordinateSystem(extent = {{-100, -200}, {100, 200}})),
      Diagram(coordinateSystem(extent = {{-100, -200}, {100, 200}})),
      __OpenModelica_commandLineOptions = "");
  end Flash;

  model Splitter
    extends Simulator.Files.Icons.Splitter;
    parameter Integer NOC = 2 "number of Components", NO = 2 "number of outputs";
    parameter Simulator.Files.Chemsep_Database.General_Properties comp[NOC];
    Real inP(start = Press) "inlet pressure", inT(start = Temp) "Inlet Temperature", outP[NO](start = {Press, Press}) "Outlet Pressure", outT[NO](start = {Temp, Temp}) "Outlet Temperature", inMixMolFrac[NOC](each min = 0, each max = 1, start = CompMolFrac) "inlet Mixture Mole Fraction", outMixMolFrac[NO, NOC](each min = 0, each max = 1, start = {CompMolFrac, CompMolFrac}) "Outlet Mixture Molar Fraction", splRat[NO](each min = 0, each max = 1) "Split ratio", MW(each min = 0) "Stream molecular weight", inMixMolFlo(start = Feed_flow) "inlet Mixture Molar Flow", outMixMolFlo[NO](each min = 0, start = Feed_flow) "Outlet Mixture Molar Flow", outMixMasFlo[NO](each min = 0, each start = Feed_flow) "Outlet Mixture Mass Flow", specVal[NO] "Specification value";
    parameter String calcType "Split_Ratio, Mass_Flow or Molar_Flow";
    //  Simulator.Files.Connection.matConn outlet[NO](each connNOC = NOC);
    Simulator.Files.Connection.matConn inlet(connNOC = NOC) annotation(
      Placement(visible = true, transformation(origin = {-100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Simulator.Files.Connection.matConn outlet[NO](each connNOC = NOC) annotation(
      Placement(visible = true, transformation(origin = {100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    extends Guess_Models.Initial_Guess;
  equation
//Connector equations
    inlet.P = inP;
    inlet.T = inT;
    inlet.mixMolFrac[1, :] = inMixMolFrac[:];
    inlet.mixMolFlo = inMixMolFlo;
    for i in 1:NO loop
      outlet[i].P = outP[i];
      outlet[i].T = outT[i];
      outlet[i].mixMolFrac[1, :] = outMixMolFrac[i, :];
      outlet[i].mixMolFlo = outMixMolFlo[i];
    end for;
//specification value assigning equation
    if calcType == "Split_Ratio" then
      splRat[:] = specVal[:];
    elseif calcType == "Molar_Flow" then
      outMixMolFlo[:] = specVal[:];
    elseif calcType == "Mass_Flow" then
      outMixMasFlo[:] = specVal[:];
    end if;
//balance equation
    for i in 1:NO loop
      inP = outP[i];
      inT = outT[i];
      inMixMolFrac[:] = outMixMolFrac[i, :];
      splRat[i] = outMixMolFlo[i] / inMixMolFlo;
      MW * outMixMolFlo[i] = outMixMasFlo[i];
    end for;
  algorithm
    MW := 0;
    for i in 1:NOC loop
      MW := MW + comp[i].MW * inMixMolFrac[i];
    end for;
  end Splitter;

  model Centrifugal_Pump
    extends Simulator.Files.Icons.Centrifugal_Pump;
    parameter Integer NOC = 2 "Number of Components";
    parameter Simulator.Files.Chemsep_Database.General_Properties comp[NOC] "Component array";
    Real inP(start = Press) "Inlet Pressure", outP(start = Press) "Outlet Pressure", inT(start = Temp) "Inlet Temperature", outT(start = Temp) "Outlet Temperature", tempInc "Temperature increase", pressInc "Pressure Increase", inMixMolEnth(start = PhasMolEnth_mix_guess) "Inlet Mixture Molar Enthalpy", outMixMolEnth(start = PhasMolEnth_mix_guess) "Outlet Mixture Molar Enthalpy", reqPow "Power required", compDens[NOC](each min = 0) "Component density", dens(min = 0) "Density", vapPress(start = Press) "Vapor pressure of Mixture at outlet Temperature", NPSH "NPSH", inMixMolFlo(min = 0, start = Feed_flow) "inlet Mixture Molar Flow", outMixMolFlo(min = 0, start = Feed_flow) "Outlet Mixture Molar flow", inMixMolFrac[NOC](each min = 0, each max = 1, start = CompMolFrac) "Inlet Mixuture Molar Fraction", outMixMolFrac[NOC](each min = 0, each max = 1, start = CompMolFrac) "Outlet Mixture Molar Fraction";
    parameter Real eff "efficiency";
    Simulator.Files.Connection.matConn inlet(connNOC = NOC) annotation(
      Placement(visible = true, transformation(origin = {-100, -2}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-100, 16}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Simulator.Files.Connection.matConn outlet(connNOC = NOC) annotation(
      Placement(visible = true, transformation(origin = {102, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {100, 100}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Simulator.Files.Connection.enConn energy annotation(
      Placement(visible = true, transformation(origin = {2, -100}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {0, -70}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    extends Guess_Models.Initial_Guess;
  equation
//Connector equation
    inlet.P = inP;
    inlet.T = inT;
    inlet.mixMolFlo = inMixMolFlo;
    inlet.mixMolEnth = inMixMolEnth;
    inlet.mixMolFrac[1, :] = inMixMolFrac[:];
    outlet.P = outP;
    outlet.T = outT;
    outlet.mixMolFlo = outMixMolFlo;
    outlet.mixMolEnth = outMixMolEnth;
    outlet.mixMolFrac[1, :] = outMixMolFrac[:];
    energy.enFlo = reqPow;
//Pump equations
//balance
    inMixMolFlo = outMixMolFlo;
    inMixMolFrac = outMixMolFrac;
    inP + pressInc = outP;
    inT + tempInc = outT;
//density
    for i in 1:NOC loop
      compDens[i] = Simulator.Files.Thermodynamic_Functions.Dens(comp[i].LiqDen, comp[i].Tc, inT, inP);
    end for;
    dens = 1 / sum(inMixMolFrac ./ compDens);
//energy balance
    outMixMolEnth = inMixMolEnth + pressInc / dens;
    reqPow = inMixMolFlo * (outMixMolEnth - inMixMolEnth) / eff;
//NPSH
    NPSH = (inP - vapPress) / dens;
//vap pressure of mixture at outT
    vapPress = sum(inMixMolFrac .* exp(comp[:].VP[2] + comp[:].VP[3] / outT + comp[:].VP[4] * log(outT) + comp[:].VP[5] .* outT .^ comp[:].VP[6]));
  end Centrifugal_Pump;

  model Adiabatic_Compressor
    extends Simulator.Files.Icons.Adiabatic_Compressor;
    // This is generic Adibatic Compressor model. For using this model we need to extend this model and respective thermodynamic model and use the new model in flowsheets. Refer adia_comp models in Test section for this.
    extends Simulator.Files.Models.Flash;
    //====================================================================================
    Real inMolFlo(start = Feed_flow) "inlet mixture molar flow rate", outMolFlo(start = Feed_flow) "outlet mixture molar flow rate", reqPow "required Power", inP(start = Press) "Inlet pressure", outP(start = Press) "Outlet pressure", pressInc "Pressure Increase", inT(start = Temp) "Inlet Temperature", outT(start = Temp) "Outlet Temperature", tempInc "Temperature increase";
    Real inMixMolEnth(start = PhasMolEnth_mix_guess) "inlet mixture molar enthalpy", outMixMolEnth(start = PhasMolEnth_mix_guess) "outlet mixture molar enthalpy", inMixMolEntr "inlet mixture molar entropy", outMixMolEntr "outlet mixture molar entropy";
    Real inVapPhasMolFrac(min = 0, max = 1, start = Beta_guess) "Inlet vapor mol fraction", outVapPhasMolFrac(min = 0, max = 1, start = Beta_guess) "Outlet Vapor Mole fraction", mixMolFrac[NOC](each min = 0, each max = 1, start = CompMolFrac) "mixture mole fraction";
    parameter Real eff "Efficiency";
    parameter Integer NOC "number of components";
    parameter Simulator.Files.Chemsep_Database.General_Properties comp[NOC];
    //========================================================================================
    extends Guess_Models.Initial_Guess;
    Files.Connection.matConn inlet(connNOC = NOC) annotation(
      Placement(visible = true, transformation(origin = {-100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Simulator.Files.Connection.matConn outlet(connNOC = NOC) annotation(
      Placement(visible = true, transformation(origin = {100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Simulator.Files.Connection.enConn energy annotation(
      Placement(visible = true, transformation(origin = {0, -100}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {0, -66}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    //========================================================================================
  equation
//connector equations
    inlet.P = inP;
    inlet.T = inT;
    inlet.mixMolFlo = inMolFlo;
    inlet.mixMolEnth = inMixMolEnth;
    inlet.mixMolEntr = inMixMolEntr;
    inlet.mixMolFrac[1, :] = mixMolFrac[:];
    inlet.vapPhasMolFrac = inVapPhasMolFrac;
    outlet.P = outP;
    outlet.T = outT;
    outlet.mixMolFlo = outMolFlo;
    outlet.mixMolEnth = outMixMolEnth;
    outlet.mixMolEntr = outMixMolEntr;
    outlet.mixMolFrac[1, :] = mixMolFrac[:];
    outlet.vapPhasMolFrac = outVapPhasMolFrac;
    energy.enFlo = reqPow;
//=============================================================================================
    inMolFlo = outMolFlo;
//material balance
    outMixMolEnth = inMixMolEnth + (phasMolEnth[1] - inMixMolEnth) / eff;
    reqPow = inMolFlo * (phasMolEnth[1] - inMixMolEnth) / eff;
//energy balance
    inP + pressInc = outP;
//pressure calculation
    inT + tempInc = outT;
//temperature calculation
//=========================================================================
//ideal flash
    inMolFlo = totMolFlo[1];
    outP = P;
    inMixMolEntr = phasMolEntr[1];
    mixMolFrac[:] = compMolFrac[1, :];
  end Adiabatic_Compressor;

  model Adiabatic_Expander
    extends Simulator.Files.Icons.Adiabatic_Expander;
    // This is generic Adibatic Expander model. For using this model we need to extend this model and respective thermodynamic model and use the new model in flowsheets. Refer adia_comp models in Test section for this.
    extends Simulator.Files.Models.Flash;
    //====================================================================================
    Real inMolFlo(start = Feed_flow) "inlet mixture molar flow rate", outMolFlo(start = Feed_flow) "outlet mixture molar flow rate", genPow "generated Power", inP(start = Press) "Inlet pressure", outP(start = Press) "Outlet pressure", pressDrop "Pressure Drop", inT(start = Temp) "Inlet Temperature", outT(start = Temp) "Outlet Temperature", tempDrop "Temperature increase";
    Real inMixMolEnth(PhasMolEnth_mix_guess) "inlet mixture molar enthalpy", outMixMolEnth(PhasMolEnth_mix_guess) "outlet mixture molar enthalpy", inMixMolEntr "inlet mixture molar entropy", outMixMolEntr "outlet mixture molar entropy";
    Real inVapPhasMolFrac(min = 0, max = 1, start = Beta_guess) "Inlet vapor mol fraction", outVapPhasMolFrac(min = 0, max = 1, start = Beta_guess) "Outlet Vapor Mole fraction", mixMolFrac[NOC](start = CompMolFrac) "mixture mole fraction";
    parameter Real eff "Efficiency";
    parameter Integer NOC "number of components";
    parameter Simulator.Files.Chemsep_Database.General_Properties comp[NOC];
    //========================================================================================
    Files.Connection.matConn inlet(connNOC = NOC) annotation(
      Placement(visible = true, transformation(origin = {-100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Simulator.Files.Connection.matConn outlet(connNOC = NOC) annotation(
      Placement(visible = true, transformation(origin = {100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Simulator.Files.Connection.enConn energy annotation(
      Placement(visible = true, transformation(origin = {0, -100}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {0, -66}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    //========================================================================================
    extends Guess_Models.Initial_Guess;
  equation
//connector equations
    inlet.P = inP;
    inlet.T = inT;
    inlet.mixMolFlo = inMolFlo;
    inlet.mixMolEnth = inMixMolEnth;
    inlet.mixMolEntr = inMixMolEntr;
    inlet.mixMolFrac[1, :] = mixMolFrac[:];
    inlet.vapPhasMolFrac = inVapPhasMolFrac;
    outlet.P = outP;
    outlet.T = outT;
    outlet.mixMolFlo = outMolFlo;
    outlet.mixMolEnth = outMixMolEnth;
    outlet.mixMolEntr = outMixMolEntr;
    outlet.mixMolFrac[1, :] = mixMolFrac[:];
    outlet.vapPhasMolFrac = outVapPhasMolFrac;
    energy.enFlo = genPow;
//=============================================================================================
    inMolFlo = outMolFlo;
//material balance
    outMixMolEnth = inMixMolEnth + (phasMolEnth[1] - inMixMolEnth) * eff;
    genPow = inMolFlo * (phasMolEnth[1] - inMixMolEnth) * eff;
//energy balance
    inP - pressDrop = outP;
//pressure calculation
    inT - tempDrop = outT;
//temperature calculation
//=========================================================================
//ideal flash
    inMolFlo = totMolFlo[1];
    outP = P;
    inMixMolEntr = phasMolEntr[1];
    mixMolFrac[:] = compMolFrac[1, :];
  end Adiabatic_Expander;

  model Conversion_Reactor
    extends Simulator.Files.Icons.Conversion_Reactor;
    //This is generic conversion reactor model. we need to extend reaction manager model with this model for using this model.
    parameter Real X[Nr] = fill(0.4, Nr) "Conversion of base component";
    parameter Integer NOC "Number of components";
    parameter Real pressDrop = 0 "pressure drop";
    parameter Real Tdef = 300 "Defined outlet temperature, only applicable if define outlet temperature mode is chosen";
    parameter Simulator.Files.Chemsep_Database.General_Properties comp[NOC];
    parameter String calcMode = "Isothermal" "Isothermal, Define_Outlet_Temperature, Adiabatic; choose the required operation";
    Real inMolFlo(start = Feed_flow) "Inlet Molar Flowrate";
    Real outMolFlo(start = Feed_flow) "Outlet Molar Flowrate";
    Real inCompMolFrac[NOC](each min = 0, each max = 1, start = CompMolFrac) "Inlet component Mole Fraction";
    Real outCompMolFrac[NOC](each min = 0, each max = 1, start = CompMolFrac) "Outlet component Mole Fraction";
    Real inMixMolEnth "Inlet Molar Enthalpy";
    Real outMixMolEnth "Outlet Molar Enthalpy";
    Real inP(start = Press) "Inlet pressure";
    Real outP(start = Press) "Outlet pressure";
    Real inT(start = Temp) "Inlet Temperature";
    Real outT(start = Temp) "Outlet Temperature";
    Real N[NOC, Nr] "Number of moles of components after reactions";
    Simulator.Files.Connection.matConn inlet(connNOC = NOC) annotation(
      Placement(visible = true, transformation(origin = {-100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Simulator.Files.Connection.matConn outlet(connNOC = NOC) annotation(
      Placement(visible = true, transformation(origin = {100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Simulator.Files.Connection.enConn energy annotation(
      Placement(visible = true, transformation(origin = {0, -98}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {0, -130}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    extends Guess_Models.Initial_Guess;
  equation
    inlet.P = inP;
    inlet.T = inT;
    inlet.mixMolFlo = inMolFlo;
    inlet.mixMolEnth = inMixMolEnth;
    inlet.mixMolFrac[1, :] = inCompMolFrac[:];
    outlet.P = outP;
    outlet.T = outT;
    outlet.mixMolFlo = outMolFlo;
    outlet.mixMolEnth = outMixMolEnth;
    outlet.mixMolFrac[1, :] = outCompMolFrac[:];
//Reactor equations
    for i in 1:NOC loop
      N[i, 1] = inMolFlo * inCompMolFrac[i] - Sc[i, 1] / Sc[Bc[1], 1] * inMolFlo * inCompMolFrac[Bc[1]] * X[1];
    end for;
    if Nr > 1 then
      for j in 2:Nr loop
        for i in 1:NOC loop
          N[i, j] = N[i, j - 1] - Sc[i, j] / Sc[Bc[j], j] * inMolFlo * inCompMolFrac[Bc[j]] * X[j];
        end for;
      end for;
    end if;
    outMolFlo = sum(N[:, Nr]);
    for i in 1:NOC loop
      outCompMolFrac[i] = N[i, Nr] / outMolFlo;
    end for;
    inP - pressDrop = outP;
    if calcMode == "Isothermal" then
      inT = outT;
      energy.enFlo = outMixMolEnth * outMolFlo - inMixMolEnth * inMolFlo;
    elseif calcMode == "Adiabatic" then
      outMixMolEnth * outMolFlo = inMixMolEnth * inMolFlo;
      energy.enFlo = 0;
    elseif calcMode == "Define_Outlet_Temperature" then
      outT = Tdef;
      energy.enFlo = outMixMolEnth * outMolFlo - inMixMolEnth * inMolFlo;
    end if;
    annotation(
      Icon(coordinateSystem(extent = {{-100, -200}, {100, 200}})),
      Diagram(coordinateSystem(extent = {{-100, -200}, {100, 200}})),
      __OpenModelica_commandLineOptions = "");
  end Conversion_Reactor;

  package PF_Reactor
    model PFR
      //Plug Flow Reactor
      //Instantiation of Simulator-Package
      extends Simulator.Files.Icons.PFR;
      import Simulator.Files.*;
      import Simulator.Files.Thermodynamic_Functions.*;
      parameter Simulator.Files.Chemsep_Database.General_Properties comp[NOC];
      parameter Integer NOC "number of compounds ";
      parameter Integer Nr "Number of reactions";
      //Input Variables-Connector
      Real T(min = 0, start = 273.15) "Inlet Temperature";
      Real P(min = 0, start = 101325) "Inlet pressure";
      //Component Molar Flow rates of respective phases
      Real compMolFlow[3, NOC](each min = 0, each start = 100);
      //Total molar flow rates of respective phases
      Real totMolFlow[3](each min = 0, each start = 100) "Total inlet molar flow rate";
      //Mole Fraction of components in respective phases
      Real compMolFrac[3, NOC](each min = 0, each max = 1, each start = 1 / (NOC + 1)) "Mole Fraction of components in inlet stream";
      Real Enth, Entr, Vapfrac(min = 0, max = 1, start = 0.5);
      //Output Variables-Connectors
      Real Tout(min = 0, start = 273.15) "Temperature for which calculations are made";
      Real Pout(min = 0, start = 101325) "outlet pressure in Pa";
      //Total molar flow rates of respective phases in the outlet streams
      Real outTotMolFlow[3](each min = 0, each start = 50) "Total Outlet Molar Flow Rate";
      Real outCompMolFlow[3, NOC](each min = 0, each start = 50) "Component outlet molar flow rate";
      Real outCompMolFrac[3, NOC](each min = 0, each start = 0.5) "Mole Fraction of components in outlet stream";
      Real outEnth, outEntr, outVapfrac(min = 0, max = 1, start = 0.5);
      //Phase-Equilibria
      Real Pdew(unit = "Pa", start = max(comp[:].Pc), min = 0);
      Real Pbubl(min = 0, unit = "Pa", start = min(comp[:].Pc));
      Real Beta(start = 0.5);
      //Phase-Equilibria-Outlet Stream
      Real Poutdew(unit = "Pa", start = max(comp[:].Pc), min = 0);
      Real Poutbubl(min = 0, unit = "Pa", start = min(comp[:].Pc));
      Real Betaout(start = 0.5);
      //Average Molecular weights-Outlets
      Real Moutavg[3](each start = 30);
      //Material Balance-Variables
      parameter Real delta_P "Pressure Drop";
      extends Simulator.Files.Thermodynamic_Packages.Raoults_Law;
      //Mass Flow Rates and Compositions
      Real totMasFlow[3](each start = 50) "Mass Flow Rate of phases";
      Real compMasFrac[3, NOC] "Mass Fraction of components in all phases";
      //Average Molecular weights
      Real Mavg[3](each start = 30);
      //Phase Volumetric Flow Rates
      Real totVolFlow[3](each start = 30);
      //Transport Properities
      Real LiqDens[NOC];
      Real Liquid_Phase_Density;
      Real VapDensity[NOC](unit = "kg/m^3");
      Real Vapour_Phase_Density;
      Real Density_Mixture;
      parameter Real Zv = 1;
      //Inlet Concentration
      Real Co[NOC];
      //Molar Flow rate inlet to reactor depending on reaction phase
      Real Fo[NOC](each min = 0, each start = 100);
      Real F[NOC](each min = 0, each start = 100);
      //Reaction-Manager-Data
      //Reaction-Phase
      parameter Integer Phase;
      Integer n "Order of the Reaction";
      Real k1[Nr] "Rate constant";
      parameter Integer Mode;
      parameter Real Tdef;
      Real Reaction_Heat "Heat of Reaction";
      //Material Balance
      Real No[NOC, Nr] "Number of moles-initial state";
      Real X[NOC](each min = 0, each max = 1, each start = 0.5) "Conversion of the reaction components";
      Real Volume(min = 0, start = 1) "Volume of the reactor";
      //Base-comp indicates the position of the base component in the comp-array
      parameter Integer Base_comp = 1;
      extends Simulator.Files.Models.ReactionManager.Reaction_Manager(NOC = NOC, comp = comp, Nr = 1, Bc = {1}, Comp = 3, Sc = {{-1}, {-1}, {1}}, DO = {{1}, {0}, {0}}, RO = {{0}, {0}, {0}}, A1 = {0.005}, E1 = {0}, A2 = {0}, E2 = {0});
      //===========================================================================================================
      //Energy-Stream-Connector
      Real energy_flo "The total energy given out/taken in due to the reactions";
      Simulator.Files.Connection.matConn inlet(connNOC = NOC) annotation(
        Placement(visible = true, transformation(origin = {-80, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-350, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
      Simulator.Files.Connection.matConn outlet(connNOC = NOC) annotation(
        Placement(visible = true, transformation(origin = {74, -2}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {350, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
      Simulator.Files.Connection.enConn en_Conn annotation(
        Placement(visible = true, transformation(origin = {0, -78}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {0, -70}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
      //============================================================================================================
    equation
//Connector-Equations
      inlet.P = P;
      inlet.T = T;
      inlet.mixMolFlo = totMolFlow[1];
      inlet.mixMolEnth = Enth;
      inlet.mixMolEntr = Entr;
      inlet.mixMolFrac[1, :] = compMolFrac[1, :];
      inlet.vapPhasMolFrac = Vapfrac;
      outlet.P = Pout;
      outlet.T = Tout;
      outlet.mixMolFlo = outTotMolFlow[1];
      outlet.mixMolEnth = outEnth;
      outlet.mixMolEntr = outEntr;
      outlet.mixMolFrac[1, :] = outCompMolFrac[1, :];
      outlet.vapPhasMolFrac = outVapfrac;
      en_Conn.enFlo = energy_flo;
//Phase Equilibria
//==========================================================================================================
//Bubble point calculation
      Pbubl = sum(gammaBubl[:] .* compMolFrac[1, :] .* exp(comp[:].VP[2] + comp[:].VP[3] / T + comp[:].VP[4] * log(T) + comp[:].VP[5] .* T .^ comp[:].VP[6]) ./ liqfugcoeff_bubl[:]);
//Dew point calculation
      Pdew = 1 / sum(compMolFrac[1, :] ./ (gammaDew[:] .* exp(comp[:].VP[2] + comp[:].VP[3] / T + comp[:].VP[4] * log(T) + comp[:].VP[5] .* T .^ comp[:].VP[6])) .* vapfugcoeff_dew[:]);
      if P >= Pbubl then
//below bubble point region
        compMolFrac[3, :] = zeros(NOC);
        sum(compMolFrac[2, :]) = 1;
      elseif P <= Pdew then
//above dew point region
        compMolFrac[2, :] = zeros(NOC);
        sum(compMolFrac[3, :]) = 1;
      else
//VLE region
        for i in 1:NOC loop
          compMolFrac[3, i] = K[i] * compMolFrac[2, i];
        end for;
        sum(compMolFrac[2, :]) = 1;
//sum y = 1
      end if;
//Rachford Rice Equation
      for i in 1:NOC loop
        compMolFrac[1, i] = compMolFrac[3, i] * Beta + compMolFrac[2, i] * (1 - Beta);
      end for;
//===========================================================================================================
//Calculation of Mass Fraction
//Average Molecular Weights of respective phases
      if Beta <= 0 then
        Mavg[1] = sum(compMolFrac[1, :] .* comp[:].MW);
        Mavg[2] = sum(compMolFrac[2, :] .* comp[:].MW);
        Mavg[3] = 0;
        totMasFlow[1] = totMolFlow[1] * 1E-3 * Mavg[1];
        totMasFlow[2] = totMolFlow[2] * 1E-3 * Mavg[2];
        totMasFlow[3] = 0;
        compMasFrac[1, :] = compMolFrac[1, :] .* comp[:].MW / Mavg[1];
        compMasFrac[2, :] = compMolFrac[2, :] .* comp[:].MW / Mavg[2];
        for i in 1:NOC loop
          compMasFrac[3, i] = 0;
        end for;
//Liquid_Phase_Density
        LiqDens = Thermodynamic_Functions.Density_Racket(NOC, T, P, comp[:].Pc, comp[:].Tc, comp[:].Racketparam, comp[:].AF, comp[:].MW, Psat[:]);
        Liquid_Phase_Density = 1 / sum(compMasFrac[2, :] ./ LiqDens[:]) / Mavg[2];
//Vapour Phase Density
        for i in 1:NOC loop
          VapDensity[i] = 0;
        end for;
        Vapour_Phase_Density = 0;
//Density of Inlet-Mixture
        Density_Mixture = 1 / ((1 - Beta) / Liquid_Phase_Density) * sum(compMolFrac[1, :] .* comp[:].MW);
//====================================================================================================
      elseif Beta == 1 then
        Mavg[1] = sum(compMolFrac[1, :] .* comp[:].MW);
        Mavg[2] = 0;
        Mavg[3] = sum(compMolFrac[3, :] .* comp[:].MW);
        totMasFlow[1] = totMolFlow[1] * 1E-3 * Mavg[1];
        totMasFlow[2] = 0;
        totMasFlow[3] = totMolFlow[3] * 1E-3 * Mavg[3];
        compMasFrac[1, :] = compMolFrac[1, :] .* comp[:].MW / Mavg[1];
        for i in 1:NOC loop
          compMasFrac[2, i] = 0;
        end for;
        compMasFrac[3, :] = compMolFrac[3, :] .* comp[:].MW / Mavg[3];
//Calculation of Phase Densities
//Liquid Phase Density-Inlet Conditions
        for i in 1:NOC loop
          LiqDens[i] = 0;
        end for;
        Liquid_Phase_Density = 0;
//Vapour Phase Density
        for i in 1:NOC loop
          VapDensity[i] = P / (Zv * 8.314 * T) * comp[i].MW * 1E-3;
        end for;
        Vapour_Phase_Density = 1 / sum(compMasFrac[3, :] ./ VapDensity[:]) / Mavg[3];
//Density of Inlet-Mixture
        Density_Mixture = 1 / (Beta / Vapour_Phase_Density) * sum(compMolFrac[1, :] .* comp[:].MW);
      else
        Mavg[1] = sum(compMolFrac[1, :] .* comp[:].MW);
        Mavg[2] = sum(compMolFrac[2, :] .* comp[:].MW);
        Mavg[3] = sum(compMolFrac[3, :] .* comp[:].MW);
        totMasFlow[1] = totMolFlow[1] * 1E-3 * Mavg[1];
        totMasFlow[2] = totMolFlow[2] * 1E-3 * Mavg[2];
        totMasFlow[3] = totMolFlow[3] * 1E-3 * Mavg[3];
        compMasFrac[1, :] = compMolFrac[1, :] .* comp[:].MW / Mavg[1];
        compMasFrac[2, :] = compMolFrac[2, :] .* comp[:].MW / Mavg[2];
        compMasFrac[3, :] = compMolFrac[3, :] .* comp[:].MW / Mavg[3];
//Calculation of Phase Densities
//Liquid Phase Density-Inlet Conditions
        LiqDens = Thermodynamic_Functions.Density_Racket(NOC, T, P, comp[:].Pc, comp[:].Tc, comp[:].Racketparam, comp[:].AF, comp[:].MW, Psat[:]);
        Liquid_Phase_Density = 1 / sum(compMasFrac[2, :] ./ LiqDens[:]) / Mavg[2];
//Vapour Phase Density
        for i in 1:NOC loop
          VapDensity[i] = P / (Zv * 8.314 * T) * comp[i].MW * 1E-3;
        end for;
        Vapour_Phase_Density = 1 / sum(compMasFrac[3, :] ./ VapDensity[:]) / Mavg[3];
//Density of Inlet-Mixture
        Density_Mixture = 1 / (Beta / Vapour_Phase_Density + (1 - Beta) / Liquid_Phase_Density) * sum(compMolFrac[1, :] .* comp[:].MW);
      end if;
//=====================================================================================================
//Phase Flow Rates
//Phase Molar Flow Rates
      totMolFlow[3] = totMolFlow[1] * Beta;
      totMolFlow[2] = totMolFlow[1] * (1 - Beta);
//Component Molar Flow Rates in Phases
      compMolFlow[1, :] = totMolFlow[1] .* compMolFrac[1, :];
      compMolFlow[2, :] = totMolFlow[2] .* compMolFrac[2, :];
      compMolFlow[3, :] = totMolFlow[3] .* compMolFrac[3, :];
//======================================================================================================
//Phase Volumetric flow rates
      if Phase == 1 then
        totVolFlow[1] = totMasFlow[1] / Density_Mixture;
        totVolFlow[2] = totMasFlow[2] / (Liquid_Phase_Density * Mavg[2]);
        totVolFlow[3] = totMasFlow[3] / (Vapour_Phase_Density * Mavg[3]);
      elseif Phase == 2 then
        totVolFlow[1] = totMasFlow[1] / Density_Mixture;
        totVolFlow[2] = totMasFlow[2] / (Liquid_Phase_Density * Mavg[2]);
        totVolFlow[3] = 0;
      else
        totVolFlow[1] = totMasFlow[1] / Density_Mixture;
        totVolFlow[2] = 0;
        totVolFlow[3] = totMasFlow[3] / (Vapour_Phase_Density * Mavg[3]);
      end if;
//Mixture Phase
//=============================================================================================================
//Inlet Concentration
      if Phase == 1 then
        Co[:] = compMolFlow[1, :] / totVolFlow[1];
        for i in 1:NOC loop
          if i == Base_comp then
            Fo[i] = compMolFlow[1, i];
            F[i] = No[i, 1] * Fo[i] + Sc[i, 1] / Bc[1] * X[Base_comp] * Fo[Base_comp];
          else
            Fo[i] = compMolFlow[1, i];
            F[i] = No[i, 1] * Fo[i] + Sc[i, 1] / Bc[1] * X[Base_comp] * compMolFlow[1, Base_comp];
          end if;
        end for;
//Conversion of Reactants
        for j in 2:NOC loop
          if Sc[j, 1] < 0 then
            X[j] = (compMolFlow[Phase, j] - F[j]) / compMolFlow[Phase, j];
          else
            X[j] = 0;
          end if;
        end for;
//=========================================================================================
//Liquid-Phase
      elseif Phase == 2 then
        Co[:] = compMolFlow[2, :] / totVolFlow[2];
        for i in 1:NOC loop
          if i == Base_comp then
            Fo[i] = compMolFlow[2, i];
            F[i] = Fo[i] + Sc[i, 1] / Bc[1] * X[Base_comp] * Fo[Base_comp];
          else
            Fo[i] = compMolFlow[1, i];
            F[i] = Fo[i] + Sc[i, 1] / Bc[1] * X[Base_comp] * Fo[Base_comp];
          end if;
        end for;
//Conversion of Reactants
        for j in 2:NOC loop
          if Sc[j, 1] < 0 then
            X[j] = (compMolFlow[Phase, j] - outCompMolFlow[Phase, j]) / compMolFlow[Phase, j];
          else
            X[j] = 0;
          end if;
        end for;
      else
//Vapour Phase
//======================================================================================================
        Co[:] = compMolFlow[3, :] / totVolFlow[3];
        for i in 1:NOC loop
          if i == Base_comp then
            Fo[i] = compMolFlow[3, i];
            F[i] = Fo[i] + Sc[i, 1] / Bc[1] * X[Base_comp] * Fo[Base_comp];
          else
            Fo[i] = compMolFlow[1, i];
            F[i] = Fo[i] + Sc[i, 1] / Bc[1] * X[Base_comp] * Fo[Base_comp];
          end if;
        end for;
//Conversion of Reactants
        for j in 2:NOC loop
          if Sc[j, 1] < 0 then
            X[j] = (compMolFlow[Phase, j] - outCompMolFlow[Phase, j]) / compMolFlow[Phase, j];
          else
            X[j] = 0;
          end if;
        end for;
      end if;
//================================================================================================
//Reaction Manager
      n = sum(DO[:]);
//Calculation of Rate Constants
      for i in 1:Nr loop
        k1[i] = Simulator.Files.Models.ReactionManager.Arhenious(Nr, A1[i], E1[i], T);
      end for;
//Material Balance
//Initial Number of Moles
      for i in 1:Nr loop
        for j in 1:NOC loop
          if Sc[j, i] > 0 then
            Sc[j, i] = No[j, i];
          else
            Sc[j, i] = -No[j, i];
          end if;
        end for;
      end for;
//Calculation of volume with respect to conversion of limiting reeactant
      Volume = Performance_PFR(n, Co[Base_comp], Fo[Base_comp], k1[1], X[Base_comp]);
//============================================================================================================
//Calculation of Heat of Reaction at the reaction temperature
//Outlet temperature and energy stream
//Isothermal Mode
      if Mode == 1 then
        Reaction_Heat = HOR[1] * 1E-3 * Fo[Base_comp] * X[Base_comp];
        Tout = T;
        energy_flo = Reaction_Heat - Enth / Mavg[1] * totMasFlow[1] + outEnth / Mavg[1] * totMasFlow[1];
//Outlet temperature defined
      elseif Mode == 2 then
        Reaction_Heat = HOR[1] * 1E-3 * Fo[Base_comp] * X[Base_comp];
        Tout = Tdef;
        energy_flo = Reaction_Heat - Enth / Mavg[1] * totMasFlow[1] + outEnth / Mavg[1] * totMasFlow[1];
//Adiabatic Mode
      else
        Reaction_Heat = HOR[1] * 1E-3 * Fo[Base_comp] * X[Base_comp];
        energy_flo = 0;
        outEnth / Moutavg[1] = Enth / Mavg[1] - Reaction_Heat;
      end if;
//===========================================================================================================
//Calculation of Outlet Pressure
      Pout = P - delta_P;
//Calculation of Mole Fraction of outlet stream
      outCompMolFrac[1, :] = F[:] / outTotMolFlow[1];
      sum(F[:]) = outTotMolFlow[1];
//===========================================================================================================
//Phase Equilibria for Outlet Stream
//Bubble point calculation
      Poutbubl = sum(gammaBubl[:] .* outCompMolFrac[1, :] .* exp(comp[:].VP[2] + comp[:].VP[3] / Tout + comp[:].VP[4] * log(Tout) + comp[:].VP[5] .* Tout .^ comp[:].VP[6]) ./ liqfugcoeff_bubl[:]);
//Dew point calculation
      Poutdew = 1 / sum(outCompMolFrac[1, :] ./ (gammaDew[:] .* exp(comp[:].VP[2] + comp[:].VP[3] / Tout + comp[:].VP[4] * log(Tout) + comp[:].VP[5] .* Tout .^ comp[:].VP[6])) .* vapfugcoeff_dew[:]);
      if Pout >= Poutbubl then
//below bubble point region
        outCompMolFrac[3, :] = zeros(NOC);
        sum(outCompMolFrac[2, :]) = 1;
      elseif Pout <= Poutdew then
//above dew point region
        outCompMolFrac[2, :] = zeros(NOC);
        sum(outCompMolFrac[3, :]) = 1;
      else
//VLE region
        for i in 1:NOC loop
          outCompMolFrac[3, i] = K[i] * outCompMolFrac[2, i];
        end for;
        sum(outCompMolFrac[2, :]) = 1;
//sum y = 1
      end if;
//Rachford Rice Equation
      for i in 1:NOC loop
        outCompMolFrac[1, i] = outCompMolFrac[3, i] * Betaout + outCompMolFrac[2, i] * (1 - Betaout);
      end for;
      outTotMolFlow[3] = outTotMolFlow[1] * Betaout;
      outTotMolFlow[2] = outTotMolFlow[1] * (1 - Betaout);
//===========================================================================================================
//Calculation of Mass Fraction
//Average Molecular Weights of respective phases
      if Betaout <= 0 then
        Moutavg[1] = sum(outCompMolFrac[1, :] .* comp[:].MW);
        Moutavg[2] = sum(outCompMolFrac[2, :] .* comp[:].MW);
        Moutavg[3] = 0;
//====================================================================================================
      elseif Betaout == 1 then
        Moutavg[1] = sum(outCompMolFrac[1, :] .* comp[:].MW);
        Moutavg[2] = 0;
        Moutavg[3] = sum(outCompMolFrac[3, :] .* comp[:].MW);
      else
        Moutavg[1] = sum(outCompMolFrac[1, :] .* comp[:].MW);
        Moutavg[2] = sum(outCompMolFrac[2, :] .* comp[:].MW);
        Moutavg[3] = sum(outCompMolFrac[3, :] .* comp[:].MW);
      end if;
//=====================================================================================================
//Component Molar Flow Rates in Phases
      outCompMolFlow[1, :] = outTotMolFlow[1] .* outCompMolFrac[1, :];
      outCompMolFlow[2, :] = outTotMolFlow[2] .* outCompMolFrac[2, :];
      outCompMolFlow[3, :] = outTotMolFlow[3] .* outCompMolFrac[3, :];
//==================================================================================================
      annotation(
        Icon(coordinateSystem(extent = {{-350, -100}, {350, 100}})),
        Diagram(coordinateSystem(extent = {{-350, -100}, {350, 100}})),
        __OpenModelica_commandLineOptions = "");
    end PFR;

    //===========================================================================================================

    function Integral
      extends Modelica.Math.Nonlinear.Interfaces.partialScalarFunction;
      input Integer n;
      input Real Cao;
      input Real Fao;
      input Real k;
    algorithm
      y := Fao / (k * Cao ^ n) * (1 / (1 - u) ^ n);
    end Integral;

    //=========================================================================================================

    function Performance_PFR
      input Integer n;
      input Real C;
      input Real F;
      input Real k;
      input Real X;
      output Real V;
    algorithm
      V := Modelica.Math.Nonlinear.quadratureLobatto(function Integral(n = n, Cao = C, Fao = F, k = k), 0, X);
    end Performance_PFR;
  end PF_Reactor;

  package Distillation_Column
    model Cond
      import Simulator.Files.*;
      parameter Integer NOC = 2;
      parameter Boolean boolFeed = false;
      parameter Chemsep_Database.General_Properties comp[NOC];
      Real P(start = Press), T(start = Temp);
      Real feedMolFlo(start = Feed_flow), sideDrawMolFlo(start = Liquid_flow), inVapMolFlo(start = Vapour_flow), outLiqMolFlo(start = Liquid_flow), feedMolFrac[NOC](start = CompMolFrac), sideDrawMolFrac[NOC](start = CompMolFrac), inVapCompMolFrac[NOC](each min = 0, each max = 1, start = x_guess), outLiqCompMolFrac[NOC](each min = 0, each max = 1, start = x_guess), feedMolEnth(start = PhasMolEnth_mix_guess), inVapMolEnth(start = PhasMolEnth_vap_guess), outLiqMolEnth(start = PhasMolEnth_liq_guess), heatLoad, sideDrawMolEnth(start = PhasMolEnth_liq_guess), outLiqCompMolEnth[NOC](start = compMolEnth_liq);
      Real compMolFrac[3, NOC](each min = 0, each max = 1, start = {CompMolFrac, x_guess, x_guess}), Pdew(start = Pmax), Pbubl(start = Pmin);
      //String sideDrawType(start = "Null");
      //L or V
      parameter String condType "Partial or Total";
      replaceable Simulator.Files.Connection.matConn feed(connNOC = NOC) if boolFeed annotation(
        Placement(visible = true, transformation(origin = {-100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
      Simulator.Files.Connection.matConn dummy_feed(connNOC = NOC, P = 0, T = 0, mixMolFrac = zeros(3, NOC), mixMolFlo = 0, mixMolEnth = 0, mixMolEntr = 0, vapPhasMolFrac = 0) if not boolFeed annotation(
        Placement(visible = true, transformation(origin = {-100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
      Simulator.Files.Connection.matConn side_draw(connNOC = NOC) annotation(
        Placement(visible = true, transformation(origin = {100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
      Simulator.Files.Connection.trayConn liquid_outlet(connNOC = NOC) annotation(
        Placement(visible = true, transformation(origin = {-50, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-50, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
      Simulator.Files.Connection.trayConn vapor_inlet(connNOC = NOC) annotation(
        Placement(visible = true, transformation(origin = {50, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {50, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
      Simulator.Files.Connection.enConn heat_load annotation(
        Placement(visible = true, transformation(origin = {100, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {100, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
      extends Guess_Models.Initial_Guess;
    equation
//connector equation
      if boolFeed then
        feed.mixMolFrac[1, :] = feedMolFrac[:];
        feed.mixMolEnth = feedMolEnth;
        feed.mixMolFlo = feedMolFlo;
      else
        dummy_feed.mixMolFrac[1, :] = feedMolFrac[:];
        dummy_feed.mixMolEnth = feedMolEnth;
        dummy_feed.mixMolFlo = feedMolFlo;
      end if;
      side_draw.P = P;
      side_draw.T = T;
      side_draw.mixMolFrac[1, :] = sideDrawMolFrac[:];
      side_draw.mixMolFlo = sideDrawMolFlo;
      side_draw.mixMolEnth = sideDrawMolEnth;
      liquid_outlet.mixMolFlo = outLiqMolFlo;
      liquid_outlet.mixMolEnth = outLiqMolEnth;
      liquid_outlet.mixMolFrac[:] = outLiqCompMolFrac[:];
      vapor_inlet.mixMolFlo = inVapMolFlo;
      vapor_inlet.mixMolEnth = inVapMolEnth;
      vapor_inlet.mixMolFrac[:] = inVapCompMolFrac[:];
      heat_load.enFlo = heatLoad;
//Adjustment for thermodynamic packages
      compMolFrac[1, :] = (sideDrawMolFlo .* sideDrawMolFrac[:] + outLiqMolFlo .* outLiqCompMolFrac[:]) ./ (sideDrawMolFlo + outLiqMolFlo);
      compMolFrac[2, :] = outLiqCompMolFrac[:];
      compMolFrac[3, :] = K[:] .* compMolFrac[2, :];
//Bubble point calculation
      Pbubl = sum(gammaBubl[:] .* compMolFrac[1, :] .* exp(comp[:].VP[2] + comp[:].VP[3] / T + comp[:].VP[4] * log(T) + comp[:].VP[5] .* T .^ comp[:].VP[6]) ./ liqfugcoeff_bubl[:]);
//Dew point calculation
      Pdew = 1 / sum(compMolFrac[1, :] ./ (gammaDew[:] .* exp(comp[:].VP[2] + comp[:].VP[3] / T + comp[:].VP[4] * log(T) + comp[:].VP[5] .* T .^ comp[:].VP[6])) .* vapfugcoeff_dew[:]);
//molar balance
//feedMolFlo + inVapMolFlo = sideDrawMolFlo + outLiqMolFlo;
      feedMolFlo .* feedMolFrac[:] + inVapMolFlo .* inVapCompMolFrac[:] = sideDrawMolFlo .* sideDrawMolFrac[:] + outLiqMolFlo .* outLiqCompMolFrac[:];
//equillibrium
      if condType == "Partial" then
        sideDrawMolFrac[:] = K[:] .* outLiqCompMolFrac[:];
      elseif condType == "Total" then
        sideDrawMolFrac[:] = outLiqCompMolFrac[:];
      end if;
//summation equation
//  sum(outLiqCompMolFrac[:]) = 1;
      sum(sideDrawMolFrac[:]) = 1;
// Enthalpy balance
      feedMolFlo * feedMolEnth + inVapMolFlo * inVapMolEnth = sideDrawMolFlo * sideDrawMolEnth + outLiqMolFlo * outLiqMolEnth + heatLoad;
//Temperature calculation
      if condType == "Total" then
        P = sum(sideDrawMolFrac[:] .* exp(comp[:].VP[2] + comp[:].VP[3] / T + comp[:].VP[4] * log(T) + comp[:].VP[5] .* T .^ comp[:].VP[6]));
      elseif condType == "Partial" then
        1 / P = sum(sideDrawMolFrac[:] ./ exp(comp[:].VP[2] + comp[:].VP[3] / T + comp[:].VP[4] * log(T) + comp[:].VP[5] .* T .^ comp[:].VP[6]));
      end if;
// outlet liquid molar enthalpy calculation
      for i in 1:NOC loop
        outLiqCompMolEnth[i] = Simulator.Files.Thermodynamic_Functions.HLiqId(comp[i].SH, comp[i].VapCp, comp[i].HOV, comp[i].Tc, T);
      end for;
      outLiqMolEnth = sum(outLiqCompMolFrac[:] .* outLiqCompMolEnth[:]) + resMolEnth[2];
      annotation(
        Diagram(coordinateSystem(extent = {{-100, -40}, {100, 40}})),
        Icon(coordinateSystem(extent = {{-100, -40}, {100, 40}})),
        __OpenModelica_commandLineOptions = "");
    end Cond;

    model DistTray
      import Simulator.Files.*;
      parameter Integer NOC = 2;
      parameter Boolean boolFeed = true;
      parameter Chemsep_Database.General_Properties comp[NOC];
      Real P(start = Press), T(start = Temp);
      Real feedMolFlo(start = Feed_flow), sideDrawMolFlo(start = Liquid_flow), vapMolFlo[2](start = {Liquid_flow, Vapour_flow}), liqMolFlo[2](start = {Liquid_flow, Vapour_flow}), feedMolFrac[NOC](start = CompMolFrac), sideDrawMolFrac[NOC](start = CompMolFrac), vapCompMolFrac[2, NOC](start = {x_guess, x_guess}), liqCompMolFrac[2, NOC](start = {x_guess, x_guess}), feedMolEnth(start = PhasMolEnth_mix_guess), vapMolEnth[2](start = {PhasMolEnth_liq_guess, PhasMolEnth_vap_guess}), liqMolEnth[2](start = {PhasMolEnth_liq_guess, PhasMolEnth_vap_guess}), heatLoad, sideDrawMolEnth, outVapCompMolEnth[NOC](start = compMolEnth_vap), outLiqCompMolEnth[NOC](start = compMolEnth_liq);
      Real compMolFrac[3, NOC](start = {CompMolFrac, x_guess, x_guess}), Pdew(start = Pmax), Pbubl(start = Pmin);
      Real dummyP1, dummyT1, dummyMixMolFrac1[3, NOC], dummyMixMolFlo1, dummyMixMolEnth1, dummyMixMolEntr1, dummyVapPhasMolFrac1;
      //this is adjustment done since OpenModelica 1.11 is not handling array modification properly
      String sideDrawType(start = "Null");
      //L or V
      replaceable Simulator.Files.Connection.matConn feed(connNOC = NOC) if boolFeed annotation(
        Placement(visible = true, transformation(origin = {-100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
      replaceable Simulator.Files.Connection.matConn dummy_feed(connNOC = NOC, P = 0, T = 0, mixMolFlo = 0, mixMolFrac = zeros(3, NOC), mixMolEnth = 0, mixMolEntr = 0, vapPhasMolFrac = 0) if not boolFeed annotation(
        Placement(visible = true, transformation(origin = {-100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
      Simulator.Files.Connection.matConn side_draw(connNOC = NOC) annotation(
        Placement(visible = true, transformation(origin = {100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
      Simulator.Files.Connection.trayConn liquid_inlet(connNOC = NOC) annotation(
        Placement(visible = true, transformation(origin = {-50, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-50, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
      Simulator.Files.Connection.trayConn liquid_outlet(connNOC = NOC) annotation(
        Placement(visible = true, transformation(origin = {-50, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-50, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
      Simulator.Files.Connection.trayConn vapor_outlet(connNOC = NOC) annotation(
        Placement(visible = true, transformation(origin = {50, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {50, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
      Simulator.Files.Connection.trayConn vapor_inlet(connNOC = NOC) annotation(
        Placement(visible = true, transformation(origin = {50, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {50, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
      Simulator.Files.Connection.enConn heat_load annotation(
        Placement(visible = true, transformation(origin = {100, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {100, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
      extends Guess_Models.Initial_Guess;
    equation
//connector equation
      if boolFeed then
        feed.P = dummyP1;
//this is adjustment done since OpenModelica 1.11 is not handling array modification properly
        feed.T = dummyT1;
        feed.mixMolFrac = dummyMixMolFrac1;
        feed.mixMolFlo = dummyMixMolFlo1;
        feed.mixMolEnth = dummyMixMolEnth1;
        feed.mixMolEntr = dummyMixMolEntr1;
        feed.vapPhasMolFrac = dummyVapPhasMolFrac1;
      else
        dummy_feed.P = dummyP1;
        dummy_feed.T = dummyT1;
        dummy_feed.mixMolFrac = dummyMixMolFrac1;
        dummy_feed.mixMolFlo = dummyMixMolFlo1;
        dummy_feed.mixMolEnth = dummyMixMolEnth1;
        dummy_feed.mixMolEntr = dummyMixMolEntr1;
        dummy_feed.vapPhasMolFrac = dummyVapPhasMolFrac1;
      end if;
//this is adjustment done since OpenModelica 1.11 is not handling array modification properly
      dummyMixMolFrac1[1, :] = feedMolFrac[:];
      dummyMixMolEnth1 = feedMolEnth;
      dummyMixMolFlo1 = feedMolFlo;
      side_draw.P = P;
      side_draw.T = T;
      side_draw.mixMolFlo = sideDrawMolFlo;
      side_draw.mixMolEnth = sideDrawMolEnth;
      liquid_inlet.mixMolFlo = liqMolFlo[1];
      liquid_inlet.mixMolEnth = liqMolEnth[1];
      liquid_inlet.mixMolFrac[:] = liqCompMolFrac[1, :];
      liquid_outlet.mixMolFlo = liqMolFlo[2];
      liquid_outlet.mixMolEnth = liqMolEnth[2];
      liquid_outlet.mixMolFrac[:] = liqCompMolFrac[2, :];
      vapor_inlet.mixMolFlo = vapMolFlo[1];
      vapor_inlet.mixMolEnth = vapMolEnth[1];
      vapor_inlet.mixMolFrac[:] = vapCompMolFrac[1, :];
      vapor_outlet.mixMolFlo = vapMolFlo[2];
      vapor_outlet.mixMolEnth = vapMolEnth[2];
      vapor_outlet.mixMolFrac[:] = vapCompMolFrac[2, :];
      heat_load.enFlo = heatLoad;
//Adjustment for thermodynamic packages
      compMolFrac[1, :] = (sideDrawMolFlo .* sideDrawMolFrac[:] + vapMolFlo[2] .* vapCompMolFrac[2, :] + liqMolFlo[2] .* liqCompMolFrac[2, :]) / (liqMolFlo[2] + vapMolFlo[2] + sideDrawMolFlo);
      compMolFrac[2, :] = liqCompMolFrac[2, :];
      compMolFrac[3, :] = vapCompMolFrac[2, :];
//Bubble point calculation
      Pbubl = sum(gammaBubl[:] .* compMolFrac[1, :] .* exp(comp[:].VP[2] + comp[:].VP[3] / T + comp[:].VP[4] * log(T) + comp[:].VP[5] .* T .^ comp[:].VP[6]) ./ liqfugcoeff_bubl[:]);
//Dew point calculation
      Pdew = 1 / sum(compMolFrac[1, :] ./ (gammaDew[:] .* exp(comp[:].VP[2] + comp[:].VP[3] / T + comp[:].VP[4] * log(T) + comp[:].VP[5] .* T .^ comp[:].VP[6])) .* vapfugcoeff_dew[:]);
//molar balance
//feedMolFlo + vapMolFlo[1] + liqMolFlo[1] = sideDrawMolFlo + vapMolFlo[2] + liqMolFlo[2];
      feedMolFlo .* feedMolFrac[:] + vapMolFlo[1] .* vapCompMolFrac[1, :] + liqMolFlo[1] .* liqCompMolFrac[1, :] = sideDrawMolFlo .* sideDrawMolFrac[:] + vapMolFlo[2] .* vapCompMolFrac[2, :] + liqMolFlo[2] .* liqCompMolFrac[2, :];
//equillibrium
      vapCompMolFrac[2, :] = K[:] .* liqCompMolFrac[2, :];
//raschford rice
//    liqCompMolFrac[2,:] = ((feedMolFlo .* feedMolFrac[:] + vapMolFlo[1] .* vapCompMolFrac[1, :] + liqMolFlo[1] .* liqCompMolFrac[1, :])./(feedMolFlo + vapMolFlo[1] + liqMolFlo[1])) ./(1 .+ (vapMolFlo[2]/ (vapMolFlo[2] + liqMolFlo[2])) * (K[:] .- 1));
//  for i in 1:NOC loop
//    vapCompMolFrac[2,i] = ((K[i]/(K[1])) * liqCompMolFrac[2,i]) / (1 + (K[i] / (K[1])) * liqCompMolFrac[2,i]);
//  end for;
//summation equation
      sum(liqCompMolFrac[2, :]) = 1;
      sum(vapCompMolFrac[2, :]) = 1;
// Enthalpy balance
      feedMolFlo * feedMolEnth + vapMolFlo[1] * vapMolEnth[1] + liqMolFlo[1] * liqMolEnth[1] = sideDrawMolFlo * sideDrawMolEnth + vapMolFlo[2] * vapMolEnth[2] + liqMolFlo[2] * liqMolEnth[2] + heatLoad;
//enthalpy calculation
      for i in 1:NOC loop
        outLiqCompMolEnth[i] = Thermodynamic_Functions.HLiqId(comp[i].SH, comp[i].VapCp, comp[i].HOV, comp[i].Tc, T);
        outVapCompMolEnth[i] = Thermodynamic_Functions.HVapId(comp[i].SH, comp[i].VapCp, comp[i].HOV, comp[i].Tc, T);
      end for;
      liqMolEnth[2] = sum(liqCompMolFrac[2, :] .* outLiqCompMolEnth[:]) + resMolEnth[2];
      vapMolEnth[2] = sum(vapCompMolFrac[2, :] .* outVapCompMolEnth[:]) + resMolEnth[3];
//sidedraw calculation
      if sideDrawType == "L" then
        sideDrawMolFrac[:] = liqCompMolFrac[2, :];
      elseif sideDrawType == "V" then
        sideDrawMolFrac[:] = vapCompMolFrac[2, :];
      else
        sideDrawMolFrac[:] = zeros(NOC);
      end if;
      annotation(
        Diagram(coordinateSystem(extent = {{-100, -40}, {100, 40}})),
        Icon(coordinateSystem(extent = {{-100, -40}, {100, 40}})),
        __OpenModelica_commandLineOptions = "");
    end DistTray;

    model Reb
      import Simulator.Files.*;
      parameter Integer NOC = 2;
      parameter Boolean boolFeed = false;
      parameter Chemsep_Database.General_Properties comp[NOC];
      Real P(start = Press), T(start = Temp);
      Real feedMolFlo(start = Feed_flow), sideDrawMolFlo(start = Liquid_flow), outVapMolFlo(start = Vapour_flow), inLiqMolFlo(start = Liquid_flow), feedMolFrac[NOC](start = CompMolFrac), sideDrawMolFrac[NOC](start = CompMolFrac), outVapCompMolFrac[NOC](start = y_guess), inLiqCompMolFrac[NOC](start = x_guess), feedMolEnth(start = PhasMolEnth_mix), outVapMolEnth(start = PhasMolEnth_vap_guess), inLiqMolEnth(start = PhasMolEnth_liq_guess), outVapCompMolEnth[NOC](start = compMolEnth_vap), heatLoad, sideDrawMolEnth;
      Real compMolFrac[3, NOC](each min = 0, each max = 1, start = {CompMolFrac, x_guess, y_guess}), Pdew(start = Pmax), Pbubl(start = Pmin);
      replaceable Simulator.Files.Connection.matConn feed(connNOC = NOC) if boolFeed annotation(
        Placement(visible = true, transformation(origin = {-100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
      replaceable Simulator.Files.Connection.matConn dummy_feed(connNOC = NOC, P = 0, T = 0, mixMolFrac = zeros(3, NOC), mixMolFlo = 0, mixMolEnth = 0, mixMolEntr = 0, vapPhasMolFrac = 0) if not boolFeed annotation(
        Placement(visible = true, transformation(origin = {-100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
      Simulator.Files.Connection.matConn side_draw(connNOC = NOC) annotation(
        Placement(visible = true, transformation(origin = {100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
      Simulator.Files.Connection.trayConn liquid_inlet(connNOC = NOC) annotation(
        Placement(visible = true, transformation(origin = {-50, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-50, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
      Simulator.Files.Connection.trayConn vapor_outlet(connNOC = NOC) annotation(
        Placement(visible = true, transformation(origin = {50, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {50, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
      Simulator.Files.Connection.enConn heat_load annotation(
        Placement(visible = true, transformation(origin = {100, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {100, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
      extends Guess_Models.Initial_Guess;
    equation
//connector equation
      if boolFeed then
        feed.mixMolFrac[1, :] = feedMolFrac[:];
        feed.mixMolEnth = feedMolEnth;
        feed.mixMolFlo = feedMolFlo;
      else
        dummy_feed.mixMolFrac[1, :] = feedMolFrac[:];
        dummy_feed.mixMolEnth = feedMolEnth;
        dummy_feed.mixMolFlo = feedMolFlo;
      end if;
      side_draw.P = P;
      side_draw.T = T;
      side_draw.mixMolFrac[1, :] = sideDrawMolFrac;
      side_draw.mixMolFlo = sideDrawMolFlo;
      side_draw.mixMolEnth = sideDrawMolEnth;
      liquid_inlet.mixMolFlo = inLiqMolFlo;
      liquid_inlet.mixMolEnth = inLiqMolEnth;
      liquid_inlet.mixMolFrac[:] = inLiqCompMolFrac[:];
      vapor_outlet.mixMolFlo = outVapMolFlo;
      vapor_outlet.mixMolEnth = outVapMolEnth;
      vapor_outlet.mixMolFrac[:] = outVapCompMolFrac[:];
      heat_load.enFlo = heatLoad;
//Adjustment for thermodynamic packages
      compMolFrac[1, :] = (sideDrawMolFlo .* sideDrawMolFrac[:] + outVapMolFlo .* outVapCompMolFrac[:]) ./ (sideDrawMolFlo + outVapMolFlo);
      compMolFrac[2, :] = sideDrawMolFrac[:];
//This equation is temporarily valid since this is only "partial" reboiler. Rewrite equation when "total" reboiler functionality is added
      compMolFrac[3, :] = outVapCompMolFrac[:];
//Bubble point calculation
      Pbubl = sum(gammaBubl[:] .* compMolFrac[1, :] .* exp(comp[:].VP[2] + comp[:].VP[3] / T + comp[:].VP[4] * log(T) + comp[:].VP[5] .* T .^ comp[:].VP[6]) ./ liqfugcoeff_bubl[:]);
//Dew point calculation
      Pdew = 1 / sum(compMolFrac[1, :] ./ (gammaDew[:] .* exp(comp[:].VP[2] + comp[:].VP[3] / T + comp[:].VP[4] * log(T) + comp[:].VP[5] .* T .^ comp[:].VP[6])) .* vapfugcoeff_dew[:]);
//molar balance
//  feedMolFlo + inLiqMolFlo = sideDrawMolFlo + outVapMolFlo;
      for i in 1:NOC loop
        feedMolFlo .* feedMolFrac[i] + inLiqMolFlo .* inLiqCompMolFrac[i] = sideDrawMolFlo .* sideDrawMolFrac[i] + outVapMolFlo .* outVapCompMolFrac[i];
      end for;
//equillibrium
      outVapCompMolFrac[:] = K[:] .* sideDrawMolFrac[:];
//summation equation
//    sum(outVapCompMolFrac[:]) = 1;
      sum(sideDrawMolFrac[:]) = 1;
      for i in 1:NOC loop
        outVapCompMolEnth[i] = Simulator.Files.Thermodynamic_Functions.HVapId(comp[i].SH, comp[i].VapCp, comp[i].HOV, comp[i].Tc, T);
      end for;
      outVapMolEnth = sum(outVapCompMolFrac[:] .* outVapCompMolEnth[:]) + resMolEnth[3];
// bubble point calculations
      P = sum(sideDrawMolFrac[:] .* exp(comp[:].VP[2] + comp[:].VP[3] / T + comp[:].VP[4] * log(T) + comp[:].VP[5] .* T .^ comp[:].VP[6]));
//    sideDrawMolFlo = 10;
      feedMolFlo * feedMolEnth + inLiqMolFlo * inLiqMolEnth = sideDrawMolFlo * sideDrawMolEnth + outVapMolFlo * outVapMolEnth + heatLoad;
      annotation(
        Diagram(coordinateSystem(extent = {{-100, -40}, {100, 40}})),
        Icon(coordinateSystem(extent = {{-100, -40}, {100, 40}})),
        __OpenModelica_commandLineOptions = "");
    end Reb;

    model DistCol
      extends Simulator.Files.Icons.Distillation_Column;
      parameter Integer NOC;
      import data = Simulator.Files.Chemsep_Database;
      parameter Simulator.Files.Chemsep_Database.General_Properties comp[NOC];
      parameter Boolean boolFeed[noOfStages] = Simulator.Files.Other_Functions.colBoolCalc(noOfStages, noOfFeeds, feedStages);
      parameter Integer noOfStages = 4, noOfSideDraws = 0, noOfHeatLoads = 0, noOfFeeds = 1, feedStages[noOfFeeds];
      parameter String condType = "Total";
      //Total or Partial
      Real refluxRatio(min = 0);
      Simulator.Files.Connection.matConn feed[noOfFeeds](each connNOC = NOC) annotation(
        Placement(visible = true, transformation(origin = {-248, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-250, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
      Simulator.Files.Connection.matConn distillate(connNOC = NOC) annotation(
        Placement(visible = true, transformation(origin = {250, 316}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {250, 298}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
      Simulator.Files.Connection.matConn bottoms(connNOC = NOC) annotation(
        Placement(visible = true, transformation(origin = {250, -296}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {252, -300}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
      Simulator.Files.Connection.enConn condensor_duty annotation(
        Placement(visible = true, transformation(origin = {246, 590}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {250, 600}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
      Simulator.Files.Connection.enConn reboiler_duty annotation(
        Placement(visible = true, transformation(origin = {252, -588}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {250, -598}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
      Simulator.Files.Connection.matConn side_draw[noOfSideDraws](each connNOC = NOC) annotation(
        Placement(visible = true, transformation(origin = {-36, 32}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-70, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
      Simulator.Files.Connection.enConn heat_load[noOfHeatLoads](each connNOC = NOC) annotation(
        Placement(visible = true, transformation(origin = {-34, -54}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-70, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    equation
      for i in 1:noOfFeeds loop
        if feedStages[i] == 1 then
          connect(feed[i], condensor.feed);
        elseif feedStages[i] == noOfStages then
          connect(feed[i], reboiler.feed);
        elseif feedStages[i] > 1 and feedStages[i] < noOfStages then
//this is adjustment done since OpenModelica 1.11 is not handling array modification properly
          feed[i].P = tray[feedStages[i] - 1].dummyP1;
          feed[i].T = tray[feedStages[i] - 1].dummyT1;
          feed[i].mixMolFlo = tray[feedStages[i] - 1].dummyMixMolFlo1;
          feed[i].mixMolFrac = tray[feedStages[i] - 1].dummyMixMolFrac1;
          feed[i].mixMolEnth = tray[feedStages[i] - 1].dummyMixMolEnth1;
          feed[i].mixMolEntr = tray[feedStages[i] - 1].dummyMixMolEntr1;
          feed[i].vapPhasMolFrac = tray[feedStages[i] - 1].dummyVapPhasMolFrac1;
        end if;
      end for;
      connect(condensor.side_draw, distillate);
      connect(reboiler.side_draw, bottoms);
      connect(condensor.heat_load, condensor_duty);
      connect(reboiler.heat_load, reboiler_duty);
      for i in 1:noOfStages - 3 loop
        connect(tray[i].liquid_outlet, tray[i + 1].liquid_inlet);
        connect(tray[i].vapor_inlet, tray[i + 1].vapor_outlet);
      end for;
      connect(tray[1].vapor_outlet, condensor.vapor_inlet);
      connect(condensor.liquid_outlet, tray[1].liquid_inlet);
      connect(tray[noOfStages - 2].liquid_outlet, reboiler.liquid_inlet);
      connect(reboiler.vapor_outlet, tray[noOfStages - 2].vapor_inlet);
//tray pressures
      for i in 1:noOfStages - 2 loop
        tray[i].P = condensor.P + i * (reboiler.P - condensor.P) / (noOfStages - 1);
      end for;
      for i in 2:noOfStages - 1 loop
        tray[i - 1].sideDrawType = "Null";
        tray[i - 1].side_draw.mixMolFrac = zeros(3, NOC);
        tray[i - 1].side_draw.mixMolFlo = 0;
        tray[i - 1].side_draw.mixMolEnth = 0;
        tray[i - 1].side_draw.mixMolEntr = 0;
        tray[i - 1].side_draw.vapPhasMolFrac = 0;
        tray[i - 1].heatLoad = 0;
      end for;
      refluxRatio = condensor.outLiqMolFlo / condensor.side_draw.mixMolFlo;
      annotation(
        Icon(coordinateSystem(extent = {{-250, -600}, {250, 600}})),
        Diagram(coordinateSystem(extent = {{-250, -600}, {250, 600}})),
        __OpenModelica_commandLineOptions = "");
    end DistCol;
  end Distillation_Column;

  package Absorption_Column
    model AbsTray
      import Simulator.Files.*;
      parameter Integer NOC;
      parameter Chemsep_Database.General_Properties comp[NOC];
      Real P(start = Press), T(start = Temp);
      Real vapMolFlo[2](start = {Liquid_flow, Vapour_flow}), liqMolFlo[2](start = {Liquid_flow, Vapour_flow}), vapCompMolFrac[2, NOC](start = {x_guess, x_guess}), liqCompMolFrac[2, NOC](each min = 0, each max = 1, start = {x_guess, x_guess}), vapMolEnth[2](start = {PhasMolEnth_liq_guess, PhasMolEnth_vap_guess}), liqMolEnth[2](start = {PhasMolEnth_liq_guess, PhasMolEnth_vap_guess}), outVapCompMolEnth[NOC](start = compMolEnth_vap), outLiqCompMolEnth[NOC](start = compMolEnth_liq);
      Real compMolFrac[3, NOC](each min = 0, each max = 0, start = {CompMolFrac, x_guess, x_guess}), Pdew(start = Pmax), Pbubl(start = Pmin);
      Simulator.Files.Connection.trayConn liquid_inlet(connNOC = NOC) annotation(
        Placement(visible = true, transformation(origin = {-50, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-50, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
      Simulator.Files.Connection.trayConn liquid_outlet(connNOC = NOC) annotation(
        Placement(visible = true, transformation(origin = {-50, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-50, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
      Simulator.Files.Connection.trayConn vapor_outlet(connNOC = NOC) annotation(
        Placement(visible = true, transformation(origin = {50, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {50, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
      Simulator.Files.Connection.trayConn vapor_inlet(connNOC = NOC) annotation(
        Placement(visible = true, transformation(origin = {50, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {50, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
      extends Guess_Models.Initial_Guess;
    equation
//connector equation
      liquid_inlet.mixMolFlo = liqMolFlo[1];
      liquid_inlet.mixMolEnth = liqMolEnth[1];
      liquid_inlet.mixMolFrac[:] = liqCompMolFrac[1, :];
      liquid_outlet.mixMolFlo = liqMolFlo[2];
      liquid_outlet.mixMolEnth = liqMolEnth[2];
      liquid_outlet.mixMolFrac[:] = liqCompMolFrac[2, :];
      vapor_inlet.mixMolFlo = vapMolFlo[1];
      vapor_inlet.mixMolEnth = vapMolEnth[1];
      vapor_inlet.mixMolFrac[:] = vapCompMolFrac[1, :];
      vapor_outlet.mixMolFlo = vapMolFlo[2];
      vapor_outlet.mixMolEnth = vapMolEnth[2];
      vapor_outlet.mixMolFrac[:] = vapCompMolFrac[2, :];
//Adjustment for thermodynamic packages
      compMolFrac[1, :] = (vapMolFlo[2] .* vapCompMolFrac[2, :] + liqMolFlo[2] .* liqCompMolFrac[2, :]) / (liqMolFlo[2] + vapMolFlo[2]);
      compMolFrac[2, :] = liqCompMolFrac[2, :];
      compMolFrac[3, :] = vapCompMolFrac[2, :];
//Bubble point calculation
      Pbubl = sum(gammaBubl[:] .* compMolFrac[1, :] .* exp(comp[:].VP[2] + comp[:].VP[3] / T + comp[:].VP[4] * log(T) + comp[:].VP[5] .* T .^ comp[:].VP[6]) ./ liqfugcoeff_bubl[:]);
//Dew point calculation
      Pdew = 1 / sum(compMolFrac[1, :] ./ (gammaDew[:] .* exp(comp[:].VP[2] + comp[:].VP[3] / T + comp[:].VP[4] * log(T) + comp[:].VP[5] .* T .^ comp[:].VP[6])) .* vapfugcoeff_dew[:]);
//molar balance
      vapMolFlo[1] .* vapCompMolFrac[1, :] + liqMolFlo[1] .* liqCompMolFrac[1, :] = vapMolFlo[2] .* vapCompMolFrac[2, :] + liqMolFlo[2] .* liqCompMolFrac[2, :];
//equillibrium
      vapCompMolFrac[2, :] = K[:] .* liqCompMolFrac[2, :];
//raschford rice
//  liqCompMolFrac[2, :] = ((vapMolFlo[1] .* vapCompMolFrac[1, :] + liqMolFlo[1] .* liqCompMolFrac[1, :])/(vapMolFlo[1] + liqMolFlo[1]))./(1 .+ (vapMolFlo[1]/(liqMolFlo[1] + vapMolFlo[1])) .* (K[:] .- 1));
//  for i in 1:NOC loop
//    vapCompMolFrac[2,i] = ((K[i]/(K[1])) * liqCompMolFrac[2,i]) / (1 + (K[i] / (K[1])) * liqCompMolFrac[2,i]);
//  end for;
//summation equation
      sum(liqCompMolFrac[2, :]) = 1;
      sum(vapCompMolFrac[2, :]) = 1;
// Enthalpy balance
      vapMolFlo[1] * vapMolEnth[1] + liqMolFlo[1] * liqMolEnth[1] = vapMolFlo[2] * vapMolEnth[2] + liqMolFlo[2] * liqMolEnth[2];
//enthalpy calculation
      for i in 1:NOC loop
        outLiqCompMolEnth[i] = Thermodynamic_Functions.HLiqId(comp[i].SH, comp[i].VapCp, comp[i].HOV, comp[i].Tc, T);
        outVapCompMolEnth[i] = Thermodynamic_Functions.HVapId(comp[i].SH, comp[i].VapCp, comp[i].HOV, comp[i].Tc, T);
      end for;
      liqMolEnth[2] = sum(liqCompMolFrac[2, :] .* outLiqCompMolEnth[:]) + resMolEnth[2];
      vapMolEnth[2] = sum(vapCompMolFrac[2, :] .* outVapCompMolEnth[:]) + resMolEnth[3];
      annotation(
        Diagram(coordinateSystem(extent = {{-100, -40}, {100, 40}})),
        Icon(coordinateSystem(extent = {{-100, -40}, {100, 40}})),
        __OpenModelica_commandLineOptions = "");
    end AbsTray;

    model AbsCol
      extends Simulator.Files.Icons.Absorption_Column;
      import data = Simulator.Files.Chemsep_Database;
      parameter Integer NOC "Number of Components";
      parameter Integer noOfStages;
      parameter data.General_Properties comp[NOC];
      Simulator.Files.Connection.matConn top_feed(connNOC = NOC) annotation(
        Placement(visible = true, transformation(origin = {-100, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-250, 302}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
      Simulator.Files.Connection.matConn bottom_feed(connNOC = NOC) annotation(
        Placement(visible = true, transformation(origin = {-100, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-250, -300}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
      Simulator.Files.Connection.matConn top_product(connNOC = NOC) annotation(
        Placement(visible = true, transformation(origin = {100, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {250, 300}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
      Simulator.Files.Connection.matConn bottom_product(connNOC = NOC) annotation(
        Placement(visible = true, transformation(origin = {100, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {250, -300}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    equation
//connector equation
      tray[1].liqMolFlo[1] = top_feed.mixMolFlo;
      tray[1].liqCompMolFrac[1, :] = top_feed.mixMolFrac[1, :];
      tray[1].liqMolEnth[1] = top_feed.mixMolEnth;
      tray[1].vapMolFlo[2] = top_product.mixMolFlo;
      tray[1].vapCompMolFrac[2, :] = top_product.mixMolFrac[1, :];
//  tray[1].vapMolEnth[2] = top_product.mixMolEnth;
      tray[1].T = top_product.T;
      tray[noOfStages].liqMolFlo[2] = bottom_product.mixMolFlo;
      tray[noOfStages].liqCompMolFrac[2, :] = bottom_product.mixMolFrac[1, :];
//  tray[noOfStages].liqMolEnth[2] = bottom_product.mixMolEnth;
      tray[noOfStages].T = bottom_product.T;
      tray[noOfStages].vapMolFlo[1] = bottom_feed.mixMolFlo;
      tray[noOfStages].vapCompMolFrac[1, :] = bottom_feed.mixMolFrac[1, :];
      tray[noOfStages].vapMolEnth[1] = bottom_feed.mixMolEnth;
      for i in 1:noOfStages - 1 loop
        connect(tray[i].liquid_outlet, tray[i + 1].liquid_inlet);
        connect(tray[i].vapor_inlet, tray[i + 1].vapor_outlet);
      end for;
//tray pressures
      for i in 2:noOfStages - 1 loop
        tray[i].P = tray[1].P + i * (tray[noOfStages].P - tray[1].P) / (noOfStages - 1);
      end for;
      tray[1].P = top_feed.P;
      tray[noOfStages].P = bottom_feed.P;
      tray[1].P = top_product.P;
      tray[noOfStages].P = bottom_product.P;
      annotation(
        Icon(coordinateSystem(extent = {{-250, -450}, {250, 450}})),
        Diagram(coordinateSystem(extent = {{-250, -450}, {250, 450}})),
        __OpenModelica_commandLineOptions = "");
    end AbsCol;
  end Absorption_Column;

  model Recycle_Block
    extends Simulator.Files.Icons.Mixer;
    //========================================================================================
    Real inMolFlo(start = Feed_flow) "inlet mixture molar flow rate", outMolFlo(start = Feed_flow) "outlet mixture molar flow rate", inP(start = Press) "Inlet pressure", outP(start = Press) "Outlet pressure", inT(start = Temp) "Inlet Temperature", outT(start = Temp) "Outlet Temperature";
    //========================================================================================
    Real inmixMolFrac[NOC](each min = 0, each max = 1, start = CompMolFrac) "mixture mole fraction", outmixMolFrac[NOC](each min = 0, each max = 1, start = CompMolFrac);
    parameter Integer NOC "number of components";
    parameter Simulator.Files.Chemsep_Database.General_Properties comp[NOC];
    //========================================================================================
    Simulator.Files.Connection.matConn inlet(connNOC = NOC) annotation(
      Placement(visible = true, transformation(origin = {-100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Simulator.Files.Connection.matConn outlet(connNOC = NOC) annotation(
      Placement(visible = true, transformation(origin = {100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {100, -2}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    //=========================================================================================
    extends Simulator.Guess_Models.Initial_Guess;
  equation
//connector equations
    inlet.P = inP;
    inlet.T = inT;
    inlet.mixMolFlo = inMolFlo;
    inlet.mixMolFrac[1, :] = inmixMolFrac[:];
    outlet.P = outP;
    outlet.T = outT;
    outlet.mixMolFlo = outMolFlo;
    outlet.mixMolFrac[1, :] = outmixMolFrac[:];
//=============================================================================================
    inMolFlo = outMolFlo;
//material balance
    inmixMolFrac = outmixMolFrac;
//energy balance
    inP = outP;
//pressure calculation
    inT = outT;
//temperature calculation
  end Recycle_Block;
end Unit_Operations;
