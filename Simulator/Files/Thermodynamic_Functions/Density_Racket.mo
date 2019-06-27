within Simulator.Files.Thermodynamic_Functions;

function Density_Racket
  input Integer NOC;
  input Real T;
  input Real P;
  input Real Pc;
  input Real Tc;
  input Real Racketpara;
  input Real AF;
  input Real MW;
  input Real Psat;
  output Real Density;
  parameter Real R = 83.14;
protected
  Real Tr, Pcm, temp, tempcor, a, b, c, d, e, Beta, f, g, h, j, k, Racketparam_new;
algorithm

    Pcm := Pc./ 100000;
    Tr := T / Tc;
    if Tr[i] > 0.99 then
      Tr[i] := 0.5;
    end if;
    if Racketparam == 0 then
      Racketparam_new := 0.29056 - 0.08775 * AF;
    else
      Racketparam_new := Racketparam;
    end if;
    temp := R * (Tc / Pcm) * Racketparam_new ^ (1 + (1 - Tr) ^ (2 / 7));
    if T < Tc then
      a := -9.070217;
      b := 62.45326;
      d := -135.1102;
      f := 4.79594;
      g := 0.250047;
      h := 1.14188;
      j := 0.0861488;
      k := 0.0344483;
      e := exp(f + g * AF + h * AF * AF);
      c := j + k * AF;
      Beta := Pc * ((-1) + a * (1 - Tr) ^ (1 / 3) + b * (1 - Tr) ^ (2 / 3) + d * (1 - Tr) + e * (1 - Tr) ^ (4 / 3));
      tempcor := temp * (1 - c * log((Beta + P) / (Beta + Psat)));
      Density := 0.001 * MW / (tempcor * 0.000001);
    else
      Density := 0.001 * MW / (temp * 0.000001);
    end if;
end Density_Racket;
