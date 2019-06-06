within Simulator.Files;

package Transport_Properties
  function LiqVis
    //This function calculates the liquid viscocity of the stream
    input Real LiqVis[6];
    input Real T;
    output Real Liqvisc;
  algorithm
    Liqvisc := exp(LiqVis[2] + LiqVis[3] / T + LiqVis[4] * log(T) + LiqVis[5] * T ^ LiqVis[6]);
  end LiqVis;

  function LiqK
    input Real LiqK[6] "from chemsep database";
    input Real T(unit = "K") "Temperature";
    output Real k_liq;
  algorithm
    k_liq := LiqK[2] + exp(LiqK[3] / T + LiqK[4] + LiqK[5] * T + LiqK[6] * T ^ 2);
  end LiqK;

  function VapK
    input Real VapK[6] "from chemsep database";
    input Real T(unit = "K") "Temperature";
    output Real k_vap;
  algorithm
    k_vap := VapK[6] + VapK[2] * T ^ VapK[3] / (1 + VapK[4] / T + VapK[5] / T ^ 2);
  end VapK;

  function VapVisc
    input Real VapVis[6] "from chemsep database";
    input Real T(unit = "K") "Temperature";
    output Real vapvisc;
  algorithm
    vapvisc := VapVis[6] + VapVis[2] * T ^ VapVis[3] / (1 + VapVis[4] / T + VapVis[5] / T ^ 2);
  end VapVisc;
end Transport_Properties;
