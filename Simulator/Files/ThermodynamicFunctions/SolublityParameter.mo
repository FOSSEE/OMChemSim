within Simulator.Files.ThermodynamicFunctions;

   function SolublityParameter
   extends Modelica.Icons.Function;
   
   input Integer Nc;
   input Real V_c[Nc];
   input Real SP_c[Nc];
   input Real x_c[Nc];
   
   output Real S;
   protected Real Vs,V;
   
   algorithm
     
     V := sum(x_c[:] .* V_c[:]);
     Vs :=   sum(x_c[:] .* V_c[:] .* SP_c[:]);
     
     if(V==0) then
     S :=0;
     else
     S := Vs / V;
     end if;
   
   end SolublityParameter;
