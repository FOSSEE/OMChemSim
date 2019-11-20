within Simulator.Files.ThermodynamicFunctions;

  function Dens
    //This function is developed by swaroop katta
    //this function calculates density of pure componets as a function of temperature using chemsep database.
    extends Modelica.Icons.Function;
    input Real LiqDen[6], Tc, T, P;
    output Real rho "units kmol/m3";
  protected
    Real Tr;
  protected
    parameter Real R = 8.314 "gas constant";
  algorithm
    Tr := T / Tc;
    if T < Tc then
      if LiqDen[1] == 105 then
        rho := LiqDen[2] / LiqDen[3] ^ (1 + (1 - T / LiqDen[4]) ^ LiqDen[5]) * 1000;
      elseif LiqDen[1] == 106 then
        rho := LiqDen[2] * (1 - Tr) ^ (LiqDen[3] + LiqDen[4] * Tr + LiqDen[5] * Tr ^ 2 + LiqDen[6] * Tr ^ 3) * 1000;
      end if;
    else
      rho := P / (R * T * 1000);
    end if;
  end Dens;
