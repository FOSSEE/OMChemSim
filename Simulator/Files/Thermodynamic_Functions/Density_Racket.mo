within Simulator.Files.Thermodynamic_Functions;

function Density_Racket
  input Integer NOC;
  input Real T;
  input Real P;
  input Real Pc[NOC];
  input Real Tc[NOC];
  input Real Racketparam[NOC];
  input Real AF[NOC];
  input Real MW[NOC];
  input Real Psat[NOC];
  output Real Density[NOC];
  parameter Real R = 83.14;
protected
  Real Tr[NOC], Pcm[NOC], temp[NOC], tempcor[NOC], a, b, c[NOC], d, e[NOC], Beta[NOC], f, g, h, j, k, Racketparam_new[NOC];
algorithm
  for i in 1:NOC loop
    Pcm[i] := Pc[i] / 100000;
    Tr[i] := T / Tc[i];
    if Tr[i] > 0.99 then
      Tr[i] := 0.5;
    end if;
    if Racketparam[i] == 0 then
      Racketparam_new[i] := 0.29056 - 0.08775 * AF[i];
    else
      Racketparam_new[i] := Racketparam[i];
    end if;
    temp[i] := R * (Tc[i] / Pcm[i]) * Racketparam_new[i] ^ (1 + (1 - Tr[i]) ^ (2 / 7));
    if T < Tc[i] then
      a := -9.070217;
      b := 62.45326;
      d := -135.1102;
      f := 4.79594;
      g := 0.250047;
      h := 1.14188;
      j := 0.0861488;
      k := 0.0344483;
      e[NOC] := exp(f + g * AF[i] + h * AF[i] * AF[i]);
      c[NOC] := j + k * AF[i];
      Beta[i] := Pc[i] * ((-1) + a * (1 - Tr[i]) ^ (1 / 3) + b * (1 - Tr[i]) ^ (2 / 3) + d * (1 - Tr[i]) + e[i] * (1 - Tr[i]) ^ (4 / 3));
      tempcor[i] := temp[i] * (1 - c[i] * log((Beta[i] + P) / (Beta[i] + Psat[i])));
      Density[i] := 0.001 * MW[i] / (tempcor[i] * 0.000001);
    else
      Density[i] := 0.001 * MW[i] / (temp[i] * 0.000001);
    end if;
  end for;
end Density_Racket;
