within Simulator.Files.ThermodynamicPackages;

  model RaoultsLaw
    import Simulator.Files.ThermodynamicFunctions.*;
    import data = Simulator.Files.ChemsepDatabase;
    parameter Integer Ncomp=2;
    parameter Simulator.Files.ChemsepDatabase.GeneralProperties C[Ncomp];
    Real K_c[Ncomp](each min = 0), Cpres_p[3], Hres_p[3], Sres_p[3];
    Real gma_c[Ncomp], gmabubl_c[Ncomp], gmadew_c[Ncomp];
    Real philiqbubl_c[Ncomp], phivapdew_c[Ncomp], Pvap_c[Ncomp];
    Real T(unit = "K"), P;
  equation
    for i in 1:Ncomp loop
      gma_c[i] = 1;
      gmabubl_c[i] = 1;
      gmadew_c[i] = 1;
      philiqbubl_c[i] = 1;
      phivapdew_c[i] = 1;
    end for;
    for i in 1:Ncomp loop
      Pvap_c[i] = Simulator.Files.ThermodynamicFunctions.Psat(C[i].VP, T);
    end for;
    for j in 1:Ncomp loop
      K_c[j] = Pvap_c[j] / P;
    end for;
    Cpres_p[:] = zeros(3);
    Hres_p[:] = zeros(3);
    Sres_p[:] = zeros(3);
  end RaoultsLaw;
