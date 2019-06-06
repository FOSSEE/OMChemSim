within Simulator.Files.Models;

model Flash
  //this is basic flash model.  comp and NOC has to be defined in model. thermodyanamic model must also be extended along with this model for K value.
  import Simulator.Files.*;
  Real totMolFlo[3](each min = 0, each start = 100), compMolFrac[3, NOC](each min = 0, each max = 1, each start = 1 / (NOC + 1)), compMolSpHeat[3, NOC], compMolEnth[3, NOC], compMolEntr[3, NOC], phasMolSpHeat[3], phasMolEnth[3], phasMolEntr[3], liqPhasMolFrac(min = 0, max = 1, start = 0.5), vapPhasMolFrac(min = 0, max = 1, start = 0.5), P(min = 0, start = 101325), T(min = 0, start = 298.15);
  Real Pbubl(start = 101325, min = 0) "Bubble point pressure", Pdew(start = 101325, min = 0) "dew point pressure";
equation
//Mole Balance
  totMolFlo[1] = totMolFlo[2] + totMolFlo[3];
  compMolFrac[1, :] .* totMolFlo[1] = compMolFrac[2, :] .* totMolFlo[2] + compMolFrac[3, :] .* totMolFlo[3];
//Bubble point calculation
  Pbubl = sum(gammaBubl[:] .* compMolFrac[1, :] .* exp(comp[:].VP[2] + comp[:].VP[3] / T + comp[:].VP[4] * log(T) + comp[:].VP[5] .* T .^ comp[:].VP[6]) ./ liqfugcoeff_bubl[:]);
//Dew point calculation
  Pdew = 1 / sum(compMolFrac[1, :] ./ (gammaDew[:] .* exp(comp[:].VP[2] + comp[:].VP[3] / T + comp[:].VP[4] * log(T) + comp[:].VP[5] .* T .^ comp[:].VP[6])) .* vapfugcoeff_dew[:]);
  if P >= Pbubl then
    compMolFrac[3, :] = zeros(NOC);
    sum(compMolFrac[2, :]) = 1;
  elseif P >= Pdew then
//VLE region
    for i in 1:NOC loop
      compMolFrac[3, i] = K[i] * compMolFrac[2, i];
    end for;
    sum(compMolFrac[3, :]) = 1;
//sum y = 1
  else
//above dew point region
    compMolFrac[2, :] = zeros(NOC);
    sum(compMolFrac[3, :]) = 1;
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
end Flash;
