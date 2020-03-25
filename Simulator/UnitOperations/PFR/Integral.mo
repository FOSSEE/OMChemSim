within Simulator.UnitOperations.PFR;

  function Integral "Function to define the integral part used in the performance equation of a plug floiw reactor"
    extends Modelica.Math.Nonlinear.Interfaces.partialScalarFunction;

        input Integer Nc;
        input Integer Nr;
        input Integer Base_comp;
        input Real Co_dummy[Nc - 1];
        input Real DO_dummy[Nc - 1, Nr];
        input Real X_dummy[Nc - 1];
        input Real X;
        input Integer Order;
        input Real DO[Nc, Nr];
        input Real Co[Nc];
        input Real Sc[Nc, Nr];
        input Real Bc[Nr];
        input Real Fao;
        input Real k;
        Real Rate;
      algorithm
        Rate := 1;
        for i in 2:Nc loop
          if DO[Base_comp, 1] == 0 then
            Rate := Rate * product((Co[i] + Sc[i, 1] / Bc[1] * Co[Base_comp] * u) ^ DO[i, 1]);
          else
            Rate := Rate * product((Co_dummy[i - 1] * (1 - X_dummy[i - 1])) ^ DO_dummy[i - 1, 1]);
          end if;
        end for;
        y := Fao / (k * (Co[Base_comp] * (1 - u)) ^ DO[Base_comp, 1] * Rate);
      end Integral;
