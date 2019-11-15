within Simulator.Files.Thermodynamic_Packages;

  model Raoults_Law
    import Simulator.Files.Thermodynamic_Functions.*;
    Real K_c[Nc](each min = 0), Cpres_p[3], Hres_p[3], Sres_p[3];
    Real gma_c[Nc], gmabubl_c[Nc], gmadew_c[Nc];
    Real philiqbubl_c[Nc], phivapdew_c[Nc], Psat_c[Nc];
  equation
    for i in 1:Nc loop
      gma_c[i] = 1;
      gmabubl_c[i] = 1;
      gmadew_c[i] = 1;
      philiqbubl_c[i] = 1;
      phivapdew_c[i] = 1;
    end for;
    for i in 1:Nc loop
      Psat_c[i] = Simulator.Files.Thermodynamic_Functions.Psat(C[i].VP, T);
    end for;
    for j in 1:Nc loop
      K_c[j] = Psat_c[j] / P;
    end for;
    Cpres_p[:] = zeros(3);
    Hres_p[:] = zeros(3);
    Sres_p[:] = zeros(3);
  end Raoults_Law;
