within Simulator.Files.ThermodynamicPackages;

 model PengRobinson
  
  //=====================================================================
  //Header files and Parameters
    import Simulator.Files.*;
    parameter Real R = 8.314 "Ideal Gas Constant";
    parameter Real kij_c[Nc, Nc](each start = 1) = Simulator.Files.Thermodynamic_Functions.BIP_PR(Nc, C.name);
  
  //======================================================================
  //Model Variables
    Real Tr_c[Nc](each start = 100) "Reduced temperature";
    Real b_c[Nc];
    Real a_c[Nc](each start = 0.5);
    Real m_c[Nc];
    Real q_c[Nc];
    Real aij_c[Nc, Nc];
    Real K_c[Nc](each start = 0.2);
    Real Pvap_c[Nc] "Saturated Vapor Pressure";
    Real philiq_c[Nc](each start = 5) "Liquid Phase Fugasity coefficient";
    Real phivap_c[Nc](each start = 5) "Vapor Phase Fugasity coefficient";
    Real gmabubl_c[Nc], gmadew_c[Nc];
    Real philiqbubl_c[Nc], phivapdew_c[Nc];
    Real Cpres_p[3], Hres_p[3], Sres_p[3];
    Real aMliq, bMliq;
    Real Aliq, Bliq;
    Real Cliq[4];
    Real Z_RL[3, 2];
    Real Zliq[3], Zll;
    Real sumxliq[Nc];
    Real aMvap, bMvap;
    Real Avap, Bvap;
    Real Cvap[4];
    Real Z_RV[3, 2];
    Real Zvap[3], Zvv;
    Real sumxvap[Nc];
    Real A, B, C, D_c[Nc], E, F, G, H_c[Nc], I_c[Nc], J_c[Nc];
    Real gma[Nc];
    
  //======================================================================
  equation
    for i in 1:Nc loop
      Pvap_c[i] = Simulator.Files.Thermodynamic_Functions.Psat(C[i].VP, T);
      gmadew_c[i] = 1;
      gmabubl_c[i] = 1;
      philiqbubl_c[i] = 1;
      phivapdew_c[i] = 1;
      gma[i] = 1;
    end for;
    Cpres_p[:] = zeros(3);
    Hres_p[:] = zeros(3);
    Sres_p[:] = zeros(3);
    Tr_c = T ./ C.Tc;
    b_c = 0.0778 * R * C.Tc ./ C.Pc;
    m_c = 0.37464 .+ 1.54226 * C.AF .- 0.26992 * C.AF .^ 2;
    q_c = 0.45724 * R ^ 2 * C.Tc .^ 2 ./ C.Pc;
    a_c = q_c .* (1 .+ m_c .* (1 .- sqrt(Tr_c))) .^ 2;
    aij_c = {{(1 - kij_c[i, j]) * sqrt(a_c[i] * a_c[j]) for i in 1:Nc} for j in 1:Nc};
    
  //======================================================================
//Liquid_Fugacity Coefficient Calculation Routine
    aMliq = sum({{compMolFrac[2, i] * compMolFrac[2, j] * aij_c[i, j] for i in 1:Nc} for j in 1:Nc});
    bMliq = sum(b_c .* compMolFrac[2, :]);
    Aliq = aMliq * P / (R * T) ^ 2;
    Bliq = bMliq * P / (R * T);
    Cliq[1] = 1;
    Cliq[2] = Bliq - 1;
    Cliq[3] = Aliq - 3 * Bliq ^ 2 - 2 * Bliq;
    Cliq[4] = Bliq ^ 3 + Bliq ^ 2 - Aliq * Bliq;
    Z_RL = Modelica.Math.Vectors.Utilities.roots(Cliq);
    Zliq = {Z_RL[i, 1] for i in 1:3};
    Zll = min({Zliq});
    sumxliq = {sum({compMolFrac[2, j] * aij_c[i, j] for j in 1:Nc}) for i in 1:Nc};
    if Zll + 2.4142135 * Bliq <= 0 then
      A = 1;
    else
      A = Zll + 2.4142135 * Bliq;
    end if;
    if Zll - 0.414213 * Bliq <= 0 then
      B = 1;
    else
      B = Zll - 0.414213 * Bliq;
    end if;
    if Zll - Bliq <= 0 then
      C = 0;
    else
      C = log(Zll - Bliq);
    end if;
    for i in 1:Nc loop
      if bMliq == 0 then
        D_c[i] = 0;
      else
        D_c[i] = b_c[i] / bMliq;
      end if;
    end for;
    for i in 1:Nc loop
      if aMliq == 0 then
        J_c[i] = 0;
      else
        J_c[i] = sumxliq[i] / aMliq;
      end if;
    end for;
    philiq_c = exp(Aliq / (Bliq * sqrt(8)) * log(A / B) .* (D_c .- 2 * J_c) .+ (Zll - 1) * D_c .- C);
  
  //======================================================================
//Vapour Fugacity Calculation Routine
    aMvap = sum({{compMolFrac[3, i] * compMolFrac[3, j] * aij_c[i, j] for i in 1:Nc} for j in 1:Nc});
    bMvap = sum(b_c .* compMolFrac[3, :]);
    Avap = aMvap * P / (R * T) ^ 2;
    Bvap = bMvap * P / (R * T);
    Cvap[1] = 1;
    Cvap[2] = Bvap - 1;
    Cvap[3] = Avap - 3 * Bvap ^ 2 - 2 * Bvap;
    Cvap[4] = Bvap ^ 3 + Bvap ^ 2 - Avap * Bvap;
    Z_RV = Modelica.Math.Vectors.Utilities.roots(Cvap);
    Zvap = {Z_RV[i, 1] for i in 1:3};
    Zvv = max({Zvap});
    sumxvap = {sum({compMolFrac[3, j] * aij_c[i, j] for j in 1:Nc}) for i in 1:Nc};
    if Zvv + 2.4142135 * Avap <= 0 then
      E = 1;
    else
      E = Zvv + 2.4142135 * Bvap;
    end if;
    if Zvv - 0.414213 * Bvap <= 0 then
      F = 1;
    else
      F = Zvv - 0.414213 * Bvap;
    end if;
    if Zvv - Bvap <= 0 then
      G = 0;
    else
      G = log(Zvv - Bvap);
    end if;
    for i in 1:Nc loop
      if bMvap == 0 then
        H_c[i] = 0;
      else
        H_c[i] = b_c[i] / bMvap;
      end if;
    end for;
    for i in 1:Nc loop
      if aMvap == 0 then
        I_c[i] = 0;
      else
        I_c[i] = sumxvap[i] / aMvap;
      end if;
    end for;
    phivap_c = exp(Avap / (Bvap * sqrt(8)) * log(E / F) .* (H_c .- 2 * I_c) .+ (Zvv - 1) * H_c .- G);
    for i in 1:Nc loop
      if philiq_c[i] == 0 or phivap_c[i] == 0 then
        K_c[i] = 0;
      else
        K_c[i] = philiq_c[i] / phivap_c[i];
      end if;
    end for;
  end PengRobinson;

  //=============================================================================================================
