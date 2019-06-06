within Simulator.Files.Thermodynamic_Functions;

function Liquid_Fugacity_Coeffcient
  input Integer NOC;
  input Real Sp[NOC];
  input Real Tc[NOC];
  input Real Pc[NOC];
  input Real w[NOC];
  input Real T, P;
  input Real V[NOC];
  input Real S;
  input Real gamma[NOC];
  output Real liqfugcoeff[NOC](each start = 2);
protected
  Real Tr[NOC];
protected
  Real Pr[NOC];
protected
  Real v0[NOC](each start = 2), v1[NOC](each start = 2), v[NOC];
protected
  Real A[10];
algorithm
  for i in 1:NOC loop
    Tr[i] := T / Tc[i];
    Pr[i] := P / Pc[i];
    if Tc[i] == 33.19 then
      A[1] := 1.50709;
      A[2] := 2.74283;
      A[3] := -0.0211;
      A[4] := 0.00011;
      A[5] := 0;
      A[6] := 0.008585;
      A[7] := 0;
      A[8] := 0;
      A[9] := 0;
      A[10] := 0;
      v0[i] := 10 ^ (A[1] + A[2] / Tr[i] + A[3] * Tr[i] + A[4] * Tr[i] * Tr[i] + A[5] * Tr[i] * Tr[i] * Tr[i] + (A[6] + A[7] * Tr[i] + A[8] * Tr[i] * Tr[i]) * Pr[i] + (A[9] + A[10] * Tr[i]) * (Pr[i] * Pr[i]) - log10(Pr[i]));
    elseif Tc[i] == 190.56 then
      A[1] := 1.36822;
      A[2] := -1.54831;
      A[3] := 0;
      A[4] := 0.02889;
      A[5] := -0.01076;
      A[6] := 0.10486;
      A[7] := -0.02529;
      A[8] := 0;
      A[9] := 0;
      A[10] := 0;
      v0[i] := 10 ^ (A[1] + A[2] / Tr[i] + A[3] * Tr[i] + A[4] * Tr[i] * Tr[i] + A[5] * Tr[i] * Tr[i] * Tr[i] + (A[6] + A[7] * Tr[i] + A[8] * Tr[i] * Tr[i]) * Pr[i] + (A[9] + A[10] * Tr[i]) * (Pr[i] * Pr[i]) - log10(Pr[i]));
    else
      A[1] := 2.05135;
      A[2] := -2.10889;
      A[3] := 0;
      A[4] := -0.19396;
      A[5] := 0.02282;
      A[6] := 0.08852;
      A[7] := 0;
      A[8] := -0.00872;
      A[9] := -0.00353;
      A[10] := 0.00203;
      v0[i] := 10 ^ (A[1] + A[2] / Tr[i] + A[3] * Tr[i] + A[4] * Tr[i] * Tr[i] + A[5] * Tr[i] * Tr[i] * Tr[i] + (A[6] + A[7] * Tr[i] + A[8] * Tr[i] * Tr[i]) * Pr[i] + (A[9] + A[10] * Tr[i]) * (Pr[i] * Pr[i]) - log10(Pr[i]));
    end if;
    v1[i] := 10 ^ ((-4.23893) + 8.65808 * Tr[i] - 1.2206 / Tr[i] - 3.15224 * Tr[i] ^ 3 - 0.025 * (Pr[i] - 0.6));
    if v1[i] == 0 then
      v[i] := 10 ^ log10(v0[i]);
    else
      v[i] := 10 ^ (log10(v0[i]) + w[i] * log10(v1[i]));
    end if;
    liqfugcoeff[i] := v[i] * gamma[i];
  end for;
end Liquid_Fugacity_Coeffcient;
