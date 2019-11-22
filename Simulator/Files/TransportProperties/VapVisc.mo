within Simulator.Files.TransportProperties;

 function VapVisc
    extends Modelica.Icons.Function;
    input Real VapVis[6] "from chemsep database";
    input Real T(unit = "K") "Temperature";
    output Real vapvisc;
  algorithm
    vapvisc := VapVis[6] + VapVis[2] * T ^ VapVis[3] / (1 + VapVis[4] / T + VapVis[5] / T ^ 2);
  end VapVisc;
