within Simulator.Files.ThermodynamicPackages;

 model GraysonStreed
  
  //====================================================================
  //Header Files and Parameters
    import Simulator.Files.Thermodynamic_Functions.*;
    parameter Real R = 8.314;
    parameter Real u = 1;
    import Simulator.Files.*;
    parameter Real W_c[Nc];
    parameter Real SP_c[Nc](each unit = "(cal/mL)^0.5");
    parameter Real V_c[Nc](each unit = "mL/mol");
    parameter Real T_c[Nc] = C.Tc;
    parameter Real Pc_c[Nc] = C.Pc;
    parameter Real Rgas = 8314470;
    
  //====================================================================
  //Model Variables
    Real Cpres_p[3], Hres_p[3], Sres_p[3];
    Real K_c[Nc];
    Real S(start = 3), gma_c[Nc];
    Real philiq_c[Nc](each start = 2), phivap_c[Nc](each start = 0.99), phivapdew_c[Nc](each start = 1.2);
    Real S_bubl, philiqbubl_c[Nc](each start = 1.5), gmabubl[Nc];
    //Vapour Phase Fugacity coefficient
    Real a_c[Nc], b_c[Nc];
    Real aij_c[Nc, Nc];
    Real amv, amvdew, bmv, bmvdew;
    Real Avap, Avapdew, Bvap(start = 3), Bvapdew;
    Real Zvap(start = 3), Zvapdew;
    Real t1_c[Nc], t3_c[Nc], t4, t2(start = 10);
    Real t1dew_c[Nc], t3dew_c[Nc], t4dew, t2dew(start = 10);
    Real Cvap[4], ZRvap[3, 2], ZVap[3];
    Real Cvapdew[4], ZRvapdew[3, 2], ZVapdew[3];
    Real gmabubl_c[Nc](each start = 0.5), gmadew_c[Nc](each start = 2.06221);
    Real gmaliq_c[Nc], Pvap_c[Nc];
    Real A_c[Nc], B_c[Nc], C_c[Nc], D_c[Nc], E, G, H_c[Nc], I, J;
    Real xliqdew_c[Nc];
    Real Tr_c[Nc];
    Real Prbubl_c[Nc](each start = 2);
    Real Vo_c[Nc](each start = 2), V1_c[Nc](each start = 2), v_c[Nc];
    Real Vs, V;
  equation
//======================================================================================================
//Calculation Routine for Liquid Phase Fugacity Coefficient
    S = Simulator.Files.ThermodynamicFunctions.SolublityParameter(Nc, V_c, SP_c, x_pc[2, :]);
    for i in 1:Nc loop
      gma_c[i] = exp(V_c[i] * (SP_c[i] - S) ^ 2 / (Rgas * T));
    end for;
    philiq_c = Simulator.Files.ThermodynamicFunctions.LiquidFugacityCoeffcient(Nc, T_c, Pc_c, W_c, T, P, V_c, S, gma_c);
    for i in 1:Nc loop
      Pvap_c[i] = Simulator.Files.ThermodynamicFunctions.Psat(C[i].VP, T);
      gmaliq_c[i] = philiq_c[i] * (P / Pvap_c[i]);
    end for;
//========================================================================================================
//Calculation Routine for Vapour Phase Fugacity Coefficient
//Calculation of Equation of State Constants
    a_c = Simulator.Files.ThermodynamicFunctions.EOSConstants(Nc, T_c, Pc_c, T);
    b_c = Simulator.Files.ThermodynamicFunctions.EOSConstantII(Nc, T_c, Pc_c, T);
    aij_c = Simulator.Files.ThermodynamicFunctions.EOSConstantIII(Nc, a_c);
    amv = Simulator.Files.ThermodynamicFunctions.EOSConstant1V(Nc, x_pc[3, :], aij_c);
    bmv = sum(x_pc[3, :] .* b_c[:]);
    Avap = amv * P / (R * T) ^ 2;
    Bvap = bmv * P / (R * T);
    for i in 1:Nc loop
      if bmv == 0 then
        C_c[i] = 0;
      else
        C_c[i] = b_c[i] / bmv;
      end if;
    end for;
    for i in 1:Nc loop
      if amv == 0 then
        D_c[i] = 0;
      else
        D_c[i] = a_c[i] / amv;
      end if;
    end for;
    for i in 1:Nc loop
      t1_c[i] = b_c[i] * (Zvap - 1) / bmv;
      t3_c[i] = Avap / (Bvap * u ^ (2 ^ 0.5)) * (C_c[i] - 2 * D_c[i] ^ 0.5);
    end for;
    t4 = log(2 * Zvap + Bvap * (u + u ^ (2 ^ 0.5))) / (2 * Zvap + Bvap * (u - u ^ (2 ^ 0.5)));
    t2 = -log(Zvap - Bvap);
    Cpres_p[:] = zeros(3);
    Hres_p[:] = zeros(3);
    Sres_p[:] = zeros(3);
    for i in 1:Nc loop
      phivap_c[i] = exp(t1_c[i] + t2 + t3_c[i] * t4);
      K_c[i] = philiq_c[i] / phivap_c[i];
    end for;
//====================================================================================================
//Bubble Point Algorithm
    V = sum(x_pc[1, :] .* V_c[:]);
    Vs = sum(x_pc[1, :] .* V_c[:] .* SP_c[:]);
    S_bubl = Vs / V;
    for i in 1:Nc loop
      gmabubl[i] = exp(V_c[i] * (SP_c[i] - S_bubl) ^ 2 / (Rgas * T));
    end for;
    for i in 1:Nc loop
      Tr_c[i] = T / T_c[i];
      if Pc_c[i] <= 0 then
        Prbubl_c[i] = 0;
      else
        Prbubl_c[i] = Pbubl / Pc_c[i];
      end if;
      if T_c[i] == 33.19 then
        Vo_c[i] = 10 ^ (1.50709 + 2.74283 / Tr_c[i] + (-0.0211) * Tr_c[i] + 0.00011 * Tr_c[i] * Tr_c[i] + 0.008585 - log10(Prbubl_c[i]));
      elseif T_c[i] == 190.56 then
        Vo_c[i] = 10 ^ (1.36822 + (-1.54831) / Tr_c[i] + 0.02889 * Tr_c[i] * Tr_c[i] + (-0.01076) * Tr_c[i] * Tr_c[i] * Tr_c[i] + 0.10486 + (-0.02529) * Tr_c[i] - log10(Prbubl_c[i]));
      else
        Vo_c[i] = 10 ^ (2.05135 + (-2.10889) / Tr_c[i] + (-0.19396) * Tr_c[i] * Tr_c[i] + 0.02282 * Tr_c[i] * Tr_c[i] * Tr_c[i] + (0.08852 + (-0.00872) * Tr_c[i] * Tr_c[i]) * Prbubl_c[i] + ((-0.00353) + 0.00203 * Tr_c[i]) * (Prbubl_c[i] * Prbubl_c[i]) - log10(Prbubl_c[i]));
      end if;
      V1_c[i] = 10 ^ ((-4.23893) + 8.65808 * Tr_c[i] - 1.2206 / Tr_c[i] - 3.15224 * Tr_c[i] ^ 3 - 0.025 * (Prbubl_c[i] - 0.6));
      if V1_c[i] == 0 then
        v_c[i] = 10 ^ log10(Vo_c[i]);
      else
        v_c[i] = 10 ^ (log10(Vo_c[i]) + W_c[i] * log10(V1_c[i]));
      end if;
      philiqbubl_c[i] = v_c[i] * gmabubl[i];
    end for;
    for i in 1:Nc loop
      gmabubl_c[i] = philiqbubl_c[i] * (Pbubl / Pvap_c[i]);
    end for;
//===================================================================================
//Dew Point Algorithm
    for i in 1:Nc loop
      if gmadew_c[i] * Pvap_c[i] == 0 then
        xliqdew_c[i] = 0;
      else
        xliqdew_c[i] = x_pc[1, i] * Pdew / (gmadew_c[i] * Pvap_c[i]);
      end if;
    end for;
    amvdew = Simulator.Files.ThermodynamicFunctions.EOSConstant1V(Nc, xliqdew_c[:], aij_c);
    bmvdew = sum(xliqdew_c[:] .* b_c[:]);
    Avapdew = amvdew * Pdew / (R * T) ^ 2;
    Bvapdew = bmvdew * Pdew / (R * T);
    for i in 1:Nc loop
      if bmvdew == 0 then
        A_c[i] = 0;
      else
        A_c[i] = b_c[i] / bmvdew;
      end if;
    end for;
    for i in 1:Nc loop
      if amvdew == 0 then
        B_c[i] = 0;
      else
        B_c[i] = a_c[i] / amvdew;
      end if;
    end for;
    if Bvapdew * u ^ (2 ^ 0.5) == 0 then
      E = 0;
    else
      E = Bvapdew * u ^ (2 ^ 0.5);
    end if;
    if E == 0 then
      G = 0;
    else
      G = Avapdew / E;
    end if;
    if bmvdew == 0 then
      I = 0;
    else
      I = (Zvapdew - 1) / bmvdew;
    end if;
    if Zvapdew - Bvapdew <= 0 then
      J = 0;
    else
      J = -log(Zvapdew - Bvapdew);
    end if;
    for i in 1:Nc loop
      t1dew_c[i] = b_c[i] * I;
      t3dew_c[i] = G * (A_c[i] - 2 * B_c[i] ^ 0.5);
    end for;
    if (2 * Zvapdew + Bvapdew * (u + u ^ (2 ^ 0.5))) / (2 * Zvapdew + Bvapdew * (u - u ^ (2 ^ 0.5))) <= 0 then
      t4dew = 0;
    else
      t4dew = log((2 * Zvapdew + Bvapdew * (u + u ^ (2 ^ 0.5))) / (2 * Zvapdew + Bvapdew * (u - u ^ (2 ^ 0.5))));
    end if;
    t2dew = J;
    for i in 1:Nc loop
      phivapdew_c[i] = exp(t1dew_c[i] + t2dew + t3dew_c[i] * t4dew);
      if Pvap_c[i] == 0 then
        H_c[i] = 0;
      else
        H_c[i] = Pdew / Pvap_c[i];
      end if;
      gmadew_c[i] = phivapdew_c[i] * H_c[i];
    end for;
  algorithm
    Cvapdew[1] := 1;
    Cvapdew[2] := -(1 + Bvapdew - u * Bvapdew);
    Cvapdew[3] := Avapdew - u * Bvapdew - u * Bvapdew ^ 2;
    Cvapdew[4] := -Avapdew * Bvapdew;
    ZRvapdew := Modelica.Math.Vectors.Utilities.roots(Cvapdew);
    ZVapdew := {ZRvapdew[i, 1] for i in 1:3};
    Zvapdew := max({ZVapdew});
  algorithm
    Cvap[1] := 1;
    Cvap[2] := -(1 + Bvap - u * Bvap);
    Cvap[3] := Avap - u * Bvap - u * Bvap ^ 2;
    Cvap[4] := -Avap * Bvap;
    ZRvap := Modelica.Math.Vectors.Utilities.roots(Cvap);
    ZVap := {ZRvap[i, 1] for i in 1:3};
    Zvap := max({ZVap});
//==========================================================================================================
  end GraysonStreed;
