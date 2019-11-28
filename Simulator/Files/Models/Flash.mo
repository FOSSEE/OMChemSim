within Simulator.Files.Models;

 model Flash
    //this is basic flash model.  comp and Nc has to be defined in model. thermodyanamic model must also be extended along with this model for K value.
    import Simulator.Files.*;
    Real F_p[3](each min = 0, start = {Fg,Fliqg,Fvapg});
    Real x_pc[3, Nc](each min = 0, each max = 1, start={xguess,xg,yg});
    Real Cp_pc[3, Nc], H_pc[3, Nc], S_pc[3, Nc], Cp_p[3], H_p[3], S_p[3];
    Real xliq(min = 0, max = 1, start = xliqg);
    Real xvap(min = 0, max = 1, start = xvapg);
    Real P(min = 0, start = Pg);
    Real T(min = 0, start = Tg);
    Real Pbubl(start = Pmin, min = 0)"Bubble point pressure";
    Real Pdew(start = Pmax, min = 0)"dew point pressure";
  
  extends GuessModels.InitialGuess;
  
  equation
//Mole Balance
    F_p[1] = F_p[2] + F_p[3];
    x_pc[1, :] .* F_p[1] = x_pc[2, :] .* F_p[2] + x_pc[3, :] .* F_p[3];

  //Bubble point calculation
    Pbubl = sum(gmabubl_c[:] .* x_pc[1, :] .* exp(C[:].VP[2] + C[:].VP[3] / T + C[:].VP[4] * log(T) + C[:].VP[5] .* T .^ C[:].VP[6]) ./ philiqbubl_c[:]);
  //Dew point calculation
    Pdew = 1 / sum(x_pc[1, :] ./ (gmadew_c[:] .* exp(C[:].VP[2] + C[:].VP[3] / T + C[:].VP[4] * log(T) + C[:].VP[5] .* T .^ C[:].VP[6])) .* phivapdew_c[:]);
    if P >= Pbubl then
      x_pc[3, :] = zeros(Nc);
  //    sum(x_pc[2, :]) = 1;
      F_p[3] = 0;
    elseif P >= Pdew then
    //VLE region
      for i in 1:Nc loop
  //      x_pc[3, i] = K[i] * x_pc[2, i];
        x_pc[2, i] = x_pc[1, i] ./ (1 + xvap * (K_c[i] - 1));
      end for;
      sum(x_pc[2, :]) = 1;
    //sum y = 1
    else
    //above dew point region
      x_pc[2, :] = zeros(Nc);
  //    sum(x_pc[3, :]) = 1;
      F_p[2] = 0;
    end if;
  //Energy Balance
    for i in 1:Nc loop
//Specific Heat and Enthalpy calculation
      Cp_pc[2, i] = ThermodynamicFunctions.LiqCpId(C[i].LiqCp, T);
      Cp_pc[3, i] = ThermodynamicFunctions.VapCpId(C[i].VapCp, T);
      H_pc[2, i] = ThermodynamicFunctions.HLiqId(C[i].SH, C[i].VapCp, C[i].HOV, C[i].Tc, T);
      H_pc[3, i] = ThermodynamicFunctions.HVapId(C[i].SH, C[i].VapCp, C[i].HOV, C[i].Tc, T);
      (S_pc[2, i], S_pc[3, i]) = ThermodynamicFunctions.SId(C[i].VapCp, C[i].HOV, C[i].Tb, C[i].Tc, T, P, x_pc[2, i], x_pc[3, i]);
    end for;
    for i in 2:3 loop
      Cp_p[i] = sum(x_pc[i, :] .* Cp_pc[i, :]) + Cpres_p[i];
      H_p[i] = sum(x_pc[i, :] .* H_pc[i, :]) + Hres_p[i];
      S_p[i] = sum(x_pc[i, :] .* S_pc[i, :]) + Sres_p[i];
    end for;
    Cp_p[1] = xliq * Cp_p[2] + xvap * Cp_p[3];
    Cp_pc[1, :] = x_pc[1, :] .* Cp_p[1];
    H_p[1] = xliq * H_p[2] + xvap * H_p[3];
    H_pc[1, :] = x_pc[1, :] .* H_p[1];
    S_p[1] = xliq * S_p[2] + xvap * S_p[3];
    S_pc[1, :] = x_pc[1, :] * S_p[1];
//phase molar fractions
    xliq = F_p[2] / F_p[1];
    xvap = F_p[3] / F_p[1];
  end Flash;
