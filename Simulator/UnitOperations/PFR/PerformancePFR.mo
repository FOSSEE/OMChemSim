within Simulator.UnitOperations.PFR;

 function PerformancePFR "Function to return the integral of the Integral function using an adaptive Lobatto rule"
 extends Modelica.Icons.Function;
    input Integer Nc;
        input Integer Nr;
        input Integer Order;
        input Integer Base_comp;
        input Real Co_dummy[Nc - 1];
        input Real DO_dummy[Nc - 1, Nr];
        input Real X_dummy[Nc - 1];
        input Real DO[Nc, Nr];
        input Real C[Nc];
        input Real Sc[Nc, Nr];
        input Real Bc[Nr];
        input Real F;
        input Real k;
        input Real X;
        output Real V;
      algorithm
        V := Modelica.Math.Nonlinear.quadratureLobatto(function Integral(Nc = Nc, Nr = Nr, Order = Order, Base_comp = Base_comp, Co_dummy = Co_dummy, DO_dummy = DO_dummy, X_dummy = X_dummy, DO = DO, Co = C, Sc = Sc, Bc = Bc, Fao = F, k = k, X = X), 0, X);
      annotation(
    Documentation(info = "<html><head></head><body>This function using an adaptive Lobattor rule calls the <a href = \"modelica://Modelica.Math.Nonlinear.quadratureLobatto\">QuadratureLobatto</a> function and return the integral of the <a href = \"modelica://Simulator.UnitOperations.PFR.Integral\">Integral</a> function used in performace equation of a PFR</body></html>"));
    end PerformancePFR;
