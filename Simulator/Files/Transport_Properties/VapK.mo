within Simulator.Files.Transport_Properties;

function VapK
  input Real VapK[6] "from chemsep database";
  input Real T(unit = "K") "Temperature";
  output Real k_vap;
algorithm
  k_vap := VapK[6] + VapK[2] * T ^ VapK[3] / (1 + VapK[4] / T + VapK[5] / T ^ 2);
end VapK;
