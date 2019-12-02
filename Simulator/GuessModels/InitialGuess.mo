within Simulator.GuessModels;

model InitialGuess

   //Inputs Required to generate Guess Values
      extends GuessInput;
      //==========================================================================================
      //Guess variables for Pressures and Temperatures
      protected
      parameter Real xguess[Nc](each fixed = false);
       parameter Real Tg(fixed = false);
       parameter Real Temp(fixed = false, start = 300);
       parameter Real Pxc[Nc](each fixed = false), Pxm[Nc](each fixed = false);
       parameter Real Px(fixed = false);
       parameter Real Pmin(fixed = false), Pmax(fixed = false);
       parameter Real Tc[Nc](each fixed = false);
       parameter Real Psatt[Nc](each fixed = false);
       parameter Real Psatbg[Nc](each fixed = false);
       parameter Real Psatdg[Nc](each fixed = false);
       parameter Real Tbg(fixed = false, start = 200);
       parameter Real Tdg(fixed = false, start = 300);
      
     //Guess Variables for Enthalpies
       parameter Real Htotg(fixed = false);
       parameter Real Hliqg(fixed = false);
       parameter Real Hvapg(fixed = false);
       parameter Real Hmixg(fixed = false);
       parameter Real Hcompg[Nc](each fixed = false);
       parameter Real Hcomplg[Nc](each fixed = false);
       parameter Real Hcompvg[Nc](each fixed = false);
      //Guess variables for MoleFractions
      parameter Real ymol[Nc](each fixed = false), xmol[Nc](each fixed = false);
      parameter Real xg[Nc](each fixed = false), yg[Nc](each fixed = false);
      
      //Guess for VLE variables
      parameter Real xvapg(fixed = false), xliqg(fixed = false);
      parameter Real Beta(fixed = false), Alpha(fixed = false);
      parameter Real K_guess[Nc](each fixed = false);
     
      //Flow Rate-Guess
      parameter Real Fliqg(fixed = false), Fvapg(fixed = false);
    
      //======================================================================================
    initial equation
     for i in 1:Nc loop
     xguess[i] = 1/Nc;
     end for;
//Initial guess for tray temperature
      Temp = (Tbg + Tdg) / 2;
//Generation of Dew Temperatures for DC_guess
      Pg = 1 / sum(xguess[:] ./ Psatdg);
//Generation of Bubble Temperature for DC guess-(Temperatures)
      Pg = sum(xguess[:] .* Psatbg[:]);
      for i in 1:Nc loop
        Psatbg[i] = Simulator.Files.ThermodynamicFunctions.Psat(C[i].VP, Tbg);
        Psatdg[i] = Simulator.Files.ThermodynamicFunctions.Psat(C[i].VP, Tdg);
      end for;
      Fg = Fliqg + Fvapg;
      xguess[1] * Fg = xg[1] * Fliqg + yg[1] * Fvapg;
//============================================================================
      Tc = C.Tc;
      for i in 1:Nc loop
        Psatt[i] = Simulator.Files.ThermodynamicFunctions.Psat(C[i].VP, Temp);
        K_guess[i] = Psatt[i] / Pg;
      end for;
      xliqg = 1 - xvapg;
//=============================================================================
      if Pg >= Pmax then
        xvapg = 0;
      elseif Pg >= Pmin then
        xvapg = (Pg - Pmin) / (Pmax - Pmin);
      else
        xvapg = 1;
      end if;
//==============================================================================
      if xvapg > 1 then
        Beta = 1;
      elseif xvapg < 0 then
        Beta = 0;
      else
        Beta = xvapg;
      end if;
      Alpha = 1 - Beta;
      for i in 1:Nc loop
        if xguess[i] <> 0 then
          if Beta > 0 and Beta <> 1 then
            ymol[i] = xguess[i] * K_guess[i] / ((K_guess[i] - 1) * xvapg + 1);
          elseif Beta == 1 then
            ymol[i] = xguess[i];
          else
            ymol[i] = 0;
          end if;
          if Beta > 0 and Beta < 1 then
            xmol[i] = ymol[i] / K_guess[i];
          elseif Beta == 0 then
            xmol[i] = xguess[i];
          else
            xmol[i] = 0;
          end if;
        else
          xmol[i] = 0;
          ymol[i] = 0;
        end if;
      end for;
      for i in 1:Nc loop
        if xmol[i] < 0 then
          xg[i] = 0;
        elseif xg[i] > 1 then
          xg[i] = 1;
        else
          xg[i] = xmol[i];
        end if;
        if ymol[i] < 0 then
          yg[i] = 0;
        elseif ymol[i] > 1 then
          yg[i] = 1;
        else
          yg[i] = ymol[i];
        end if;
      end for;
//Algorithm for computing the minimum pressure and maximum pressure of the system
      for i in 1:Nc loop
        Pxc[i] = xguess[i] / Psatt[i];
      end for;
      Px = sum(Pxc[:]);
      Pmin = 1 / Px;
      for i in 1:Nc loop
        Pxm[i] = xguess[i] * Psatt[i];
      end for;
      Pmax = sum(Pxm[:]);
//Generating the temperature in case of PH Flash
      Tg = Temp;
      Htotg = Hmixg;
      for i in 1:Nc loop
        Hcompg[i] = xguess[i] * Htotg;
        Hcomplg[i] = Simulator.Files.ThermodynamicFunctions.HLiqId(C[i].SH, C[i].VapCp, C[i].HOV, C[i].Tc, Temp);
        Hcompvg[i] = Simulator.Files.ThermodynamicFunctions.HVapId(C[i].SH, C[i].VapCp, C[i].HOV, C[i].Tc, Temp);
      end for;
      Htotg = Hliqg + Hvapg;
      Hliqg = sum(xguess .* Hcomplg);
      Hvapg = sum(xguess .* Hcompvg);
    equation
end InitialGuess;
