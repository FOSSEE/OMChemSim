within Simulator.Files.ThermodynamicFunctions;

  function HV
    /*Returns Heat of Vaporization*/
    extends Modelica.Icons.Function;
    input Real HOV[6] "from chemsep database";
    input Real Tc(unit = "K") "Critical Temperature";
    input Real T(unit = "K") "Temperature";
    output Real Hvap(unit = "J/mol") "Heat of Vaporization";
  protected
    Real Tr = T / Tc;
  algorithm
    if T < Tc then
      Hvap := HOV[2] * (1 - Tr) ^ (HOV[3] + HOV[4] * Tr + HOV[5] * Tr ^ 2 + HOV[6] * Tr ^ 3) / 1000;
    else
      Hvap := 0;
    end if;
  end HV;
