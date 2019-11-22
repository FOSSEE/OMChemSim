within Simulator.Files.ThermodynamicFunctions;

  function SId
    extends Modelica.Icons.Function;
    import Modelica.Constants.*;
    
    
    input Real VapCp[6];
    input Real HOV[6];
    input Real Tb;
    input Real Tc;
    input Real T;
    input Real P;
    input Real xliq;
    input Real xvap;
    output Real Sliq, Svap;
  protected
    parameter Real Tref = 298.15, Pref = 101325;
    Real S, Cp[n - 1];
    parameter Integer n = 10;
  
  algorithm
    S := 0;
    for i in 1:n - 1 loop
      Cp[i] := Simulator.Files.ThermodynamicFunctions.VapCpId(VapCp, 298.15 + i * (T - 298.15) / n) / (298.15 + i * (T - 298.15) / n);
    end for;
    if T >= Tref then
      S := (T - 298.15) * (Simulator.Files.ThermodynamicFunctions.VapCpId(VapCp, T) / (2 * T) + sum(Cp[:]) + Simulator.Files.ThermodynamicFunctions.VapCpId(VapCp, 298.15) / (2 * 298.15)) / n;
    else
      S := -(T - 298.15) * (Simulator.Files.ThermodynamicFunctions.VapCpId(VapCp, T) / (2 * T) + sum(Cp[:]) + Simulator.Files.ThermodynamicFunctions.VapCpId(VapCp, 298.15) / (2 * 298.15)) / n;
    end if;
    if xliq > 0 and xvap > 0 then
      Sliq := S - R * log(P / Pref) - R * log(xliq) - HV(HOV, Tc, T) / T;
      Svap := S - R * log(P / Pref) - R * log(xvap);
    elseif xliq <= 0 and xvap <= 0 then
      Sliq := 0;
      Svap := 0;
    elseif xliq == 0 then
      Sliq := 0;
      Svap := S - R * log(P / Pref) - R * log(xvap);
    elseif xvap == 0 then
      Sliq := S - R * log(P / Pref) - R * log(xliq) - HV(HOV, Tc, T) / T;
      Svap := 0;
    else
      Sliq := 0;
      Svap := 0;
    end if;
  end SId;
