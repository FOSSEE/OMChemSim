within Simulator.Files.ThermodynamicFunctions;

  function HVapId
    /* Calculates enthalpy of ideal vapor */
    extends Modelica.Icons.Function;
    input Real SH(unit = "J/kmol") "from chemsep database std. Heat of formation";
    input Real VapCp[6] "from chemsep database";
    input Real HOV[6] "from chemsep database";
    input Real Tc "critical temp, from chemsep database";
    input Real T(unit = "K") "Temperature";
    output Real Hvap(unit = "J/mol") "Molar Enthalpy";
  protected
    Integer n = 100;
    Real Cp[n - 1];
  algorithm
    for i in 1:n - 1 loop
      Cp[i] := VapCpId(VapCp, 298.15 + i * (T - 298.15) / n);
    end for;
    Hvap := (T - 298.15) * (VapCpId(VapCp, T) / 2 + sum(Cp[:]) + VapCpId(VapCp, 298.15) / 2) / n;
  end HVapId;
