within Simulator.Files.Thermodynamic_Functions;

function SId
  import Modelica.Constants.*;
  input Real AS;
  input Real VapCp[6];
  input Real HOV[6];
  input Real Tb;
  input Real Tc;
  input Real T;
  input Real P;
  input Real x;
  input Real y;
  output Real Sliq, Svap;
protected
  parameter Real Tref = 298.15, Pref = 101325;
  Real Entr, Cp[n - 1];
  parameter Integer n = 10;
algorithm
  Entr := 0;
  for i in 1:n - 1 loop
    Cp[i] := Simulator.Files.Thermodynamic_Functions.VapCpId(VapCp, 298.15 + i * (T - 298.15) / n) / (298.15 + i * (T - 298.15) / n);
  end for;
  if T >= Tref then
    Entr := (T - 298.15) * (Simulator.Files.Thermodynamic_Functions.VapCpId(VapCp, T) / (2 * T) + sum(Cp[:]) + Simulator.Files.Thermodynamic_Functions.VapCpId(VapCp, 298.15) / (2 * 298.15)) / n;
  else
    Entr := -(T - 298.15) * (Simulator.Files.Thermodynamic_Functions.VapCpId(VapCp, T) / (2 * T) + sum(Cp[:]) + Simulator.Files.Thermodynamic_Functions.VapCpId(VapCp, 298.15) / (2 * 298.15)) / n;
  end if;
  if x > 0 and y > 0 then
    Sliq := Entr - R * log(P / Pref) - R * log(x) - HV(HOV, Tc, T) / T;
    Svap := Entr - R * log(P / Pref) - R * log(y);
  elseif x <= 0 and y <= 0 then
    Sliq := 0;
    Svap := 0;
  elseif x == 0 then
    Sliq := 0;
    Svap := Entr - R * log(P / Pref) - R * log(y);
  elseif y == 0 then
    Sliq := Entr - R * log(P / Pref) - R * log(x) - HV(HOV, Tc, T) / T;
    Svap := 0;
  else
    Sliq := 0;
    Svap := 0;
  end if;
end SId;
