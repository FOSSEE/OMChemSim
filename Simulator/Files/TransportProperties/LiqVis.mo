within Simulator.Files.TransportProperties;

 function LiqVis
    extends Modelica.Icons.Function;
    //This function calculates the liquid viscocity of the stream
    input Real LiqVis[6];
    input Real T;
    output Real Liqvisc;
  algorithm
    Liqvisc := exp(LiqVis[2] + LiqVis[3] / T + LiqVis[4] * log(T) + LiqVis[5] * T ^ LiqVis[6]);
  end LiqVis;
