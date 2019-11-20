within Simulator.Files.ThermodynamicFunctions;

 function TowUNIQUAC 
  extends Modelica.Icons.Function;
  input Integer Nc;
  input  Real a_cc[Nc,Nc];
  input Real T;
  output Real tau_cc[Nc,Nc](start = 1);
  
  protected  Real R = 1.98721;
  algorithm
  
    for i in 1:Nc  loop
      for j in 1:Nc  loop
        tau_cc[i,j] := exp(-a_cc[i,j]/(R * T));
      end for;
    end for;

end TowUNIQUAC ;
