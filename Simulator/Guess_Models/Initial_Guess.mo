within Simulator.Guess_Models;

model Initial_Guess
  //Inputs Required to generate Guess Values
  extends Guess_Input;
  parameter Real PhasMolEnth_mix(fixed = false);
  parameter Real Temp(fixed = false, start = 300);
  //==========================================================================================
  //Properties -Fluid
  parameter Real Tc[NOC](each fixed = false);
  parameter Real Psatt[NOC](each fixed = false);
  parameter Real K_guess[NOC](each fixed = false);
  parameter Real x_guess[NOC](each fixed = false), y_guess[NOC](each fixed = false);
  parameter Real Beta_guess(fixed = false), Alpha_guess(fixed = false);
  parameter Real Beta(fixed = false), Alpha(fixed = false);
  parameter Real T_guess(fixed = false);
  parameter Real Pxc[NOC](each fixed = false), Pxm[NOC](each fixed = false);
  parameter Real Px(fixed = false);
  parameter Real Pmin(fixed = false), Pmax(fixed = false);
  parameter Real y[NOC](each fixed = false), x[NOC](each fixed = false);
  //Energy Balance Guess
  //parameter Real PhasMolEnth_mix(fixed = false);
  parameter Real PhasMolEnth_mix_guess(fixed = false);
  parameter Real PhasMolEnth_liq_guess(fixed = false);
  parameter Real PhasMolEnth_vap_guess(fixed = false);
  parameter Real compMolEnth_mix[NOC](each fixed = false);
  parameter Real compMolEnth_liq[NOC](each fixed = false);
  parameter Real compMolEnth_vap[NOC](each fixed = false);
  //Flow Rate-Guess
  parameter Real Liquid_flow(fixed = false), Vapour_flow(fixed = false);
  parameter Real Psat_bubble[NOC](each fixed = false);
  parameter Real Psat_dew[NOC](each fixed = false);
  //parameter Real Psat_column[NOC](each fixed = false);
  parameter Real T_bubble(fixed = false, start = 200);
  parameter Real T_dew(fixed = false, start = 300);
  //parameter Real Tray_temp(fixed=false,start=300);
  //======================================================================================
initial equation
//Initial guess for tray temperature
  Temp = (T_bubble + T_dew) / 2;
//Generation of Dew Temperatures for DC_guess
  Press = 1 / sum(CompMolFrac[:] ./ Psat_dew);
//Generation of Bubble Temperature for DC guess-(Temperatures)
  Press = sum(CompMolFrac[:] .* Psat_bubble[:]);
  for i in 1:NOC loop
    Psat_bubble[i] = Simulator.Files.Thermodynamic_Functions.Psat(comp[i].VP, T_bubble);
    Psat_dew[i] = Simulator.Files.Thermodynamic_Functions.Psat(comp[i].VP, T_dew);
  end for;
  Feed_flow = Liquid_flow + Vapour_flow;
  CompMolFrac[1] * Feed_flow = x_guess[1] * Liquid_flow + y_guess[1] * Vapour_flow;
//============================================================================
  Tc = comp.Tc;
  for i in 1:NOC loop
    Psatt[i] = Simulator.Files.Thermodynamic_Functions.Psat(comp[i].VP, Temp);
    K_guess[i] = Psatt[i] / Press;
  end for;
  Alpha_guess = 1 - Beta_guess;
//=============================================================================
  if Press >= Pmax then
    Beta_guess = 0;
  elseif Press >= Pmin then
    Beta_guess = (Press - Pmin) / (Pmax - Pmin);
  else
    Beta_guess = 1;
  end if;
//==============================================================================
  if Beta_guess > 1 then
    Beta = 1;
  elseif Beta_guess < 0 then
    Beta = 0;
  else
    Beta = Beta_guess;
  end if;
  Alpha = 1 - Beta;
  for i in 1:NOC loop
    if CompMolFrac[i] <> 0 then
      if Beta > 0 and Beta <> 1 then
        y[i] = CompMolFrac[i] * K_guess[i] / ((K_guess[i] - 1) * Beta_guess + 1);
      elseif Beta == 1 then
        y[i] = CompMolFrac[i];
      else
        y[i] = 0;
      end if;
      if Beta > 0 and Beta < 1 then
        x[i] = y[i] / K_guess[i];
      elseif Beta == 0 then
        x[i] = CompMolFrac[i];
      else
        x[i] = 0;
      end if;
    else
      x[i] = 0;
      y[i] = 0;
    end if;
  end for;
  for i in 1:NOC loop
    if x[i] < 0 then
      x_guess[i] = 0;
    elseif x_guess[i] > 1 then
      x_guess[i] = 1;
    else
      x_guess[i] = x[i];
    end if;
    if y[i] < 0 then
      y_guess[i] = 0;
    elseif y[i] > 1 then
      y_guess[i] = 1;
    else
      y_guess[i] = y[i];
    end if;
  end for;
//Algorithm for computing the minimum pressure and maximum pressure of the system
  for i in 1:NOC loop
    Pxc[i] = CompMolFrac[i] / Psatt[i];
  end for;
  Px = sum(Pxc[:]);
  Pmin = 1 / Px;
  for i in 1:NOC loop
    Pxm[i] = CompMolFrac[i] * Psatt[i];
  end for;
  Pmax = sum(Pxm[:]);
//Generating the temperature in case of PH Flash
  T_guess = Temp;
  PhasMolEnth_mix_guess = PhasMolEnth_mix;
  for i in 1:NOC loop
    compMolEnth_mix[i] = CompMolFrac[i] * PhasMolEnth_mix_guess;
    compMolEnth_liq[i] = Simulator.Files.Thermodynamic_Functions.HLiqId(comp[i].SH, comp[i].VapCp, comp[i].HOV, comp[i].Tc, Temp);
    compMolEnth_vap[i] = Simulator.Files.Thermodynamic_Functions.HVapId(comp[i].SH, comp[i].VapCp, comp[i].HOV, comp[i].Tc, Temp);
  end for;
  PhasMolEnth_mix_guess = PhasMolEnth_liq_guess + PhasMolEnth_vap_guess;
  PhasMolEnth_liq_guess = sum(CompMolFrac .* compMolEnth_liq);
  PhasMolEnth_vap_guess = sum(CompMolFrac .* compMolEnth_vap);
equation

end Initial_Guess;
