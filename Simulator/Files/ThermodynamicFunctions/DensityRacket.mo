within Simulator.Files.ThermodynamicFunctions;

  function DensityRacket
  extends Modelica.Icons.Function;
  input Integer Nc;
  input Real T;
  input Real P;
  input Real Pc_c[Nc];
  input Real Tc_c[Nc];
  input Real RP_c[Nc];
  input Real AF_c[Nc];
  input Real MW_c[Nc];
  input Real Psat[Nc];
  output Real rho_c[Nc];
  parameter Real R = 83.14;
protected
  Real Tr_c[Nc], Pcbar_c[Nc], temp[Nc], Tcor_c[Nc], a, b, c_c[Nc], d, e_c[Nc], Beta_c[Nc], f, g, h, j, k, RPnew_c[Nc];
algorithm
  for i in 1:Nc loop
    Pcbar_c[i] := Pc_c[i] / 100000;
    Tr_c[i] := T / Tc_c[i];
    if Tr_c[i] > 0.99 then
      Tr_c[i] := 0.5;
    end if;
    if RP_c[i] == 0 then
      RPnew_c[i] := 0.29056 - 0.08775 * AF_c[i];
    else
      RPnew_c[i] := RP_c[i];
    end if;
    temp[i] := R * (Tc_c[i] / Pcbar_c[i]) * RPnew_c[i] ^ (1 + (1 - Tr_c[i]) ^ (2 / 7));
    if T < Tc_c[i] then
      a := -9.070217;
      b := 62.45326;
      d := -135.1102;
      f := 4.79594;
      g := 0.250047;
      h := 1.14188;
      j := 0.0861488;
      k := 0.0344483;
      e_c[Nc] := exp(f + g * AF_c[i] + h * AF_c[i] * AF_c[i]);
      c_c[Nc] := j + k * AF_c[i];
      Beta_c[i] := Pc_c[i] * ((-1) + a * (1 - Tr_c[i]) ^ (1 / 3) + b * (1 - Tr_c[i]) ^ (2 / 3) + d * (1 - Tr_c[i]) + e_c[i] * (1 - Tr_c[i]) ^ (4 / 3));
      Tcor_c[i] := temp[i] * (1 - c_c[i] * log((Beta_c[i] + P) / (Beta_c[i] + Psat[i])));
      rho_c[i] := 0.001 * MW_c[i] / (Tcor_c[i] * 0.000001);
    else
      rho_c[i] := 0.001 * MW_c[i] / (temp[i] * 0.000001);
    end if;
  end for;
end DensityRacket;
