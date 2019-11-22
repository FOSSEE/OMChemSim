within Simulator.Files.ThermodynamicFunctions;

function PoyntingCF
  extends Modelica.Icons.Function;
  import Simulator.Files.Thermodynamic_Functions.*;
  input Integer Nc;
  input Real Pc, Tc, RP, AF, MW;
  input Real T, P;
  input Real gma, Psat, rho;
  parameter Integer Choice = 2;
  output Real PCF;
protected
  Real vl;
algorithm
    if T < 0.98 * Tc then
      vl := 1 / rho;
    end if;
    
    if Choice == 1 then
      PCF := exp(vl * abs(P - Psat) / (8314.47 * T));
    else
      PCF := 1;
    end if;
end PoyntingCF;
