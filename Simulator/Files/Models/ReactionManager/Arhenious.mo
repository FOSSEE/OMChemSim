within Simulator.Files.Models.ReactionManager;

    function Arhenious
      extends Modelica.Icons.Function;
    // Reaction rate constant k = A*exp(-E/RT)
      input Integer Nr ;    
      input Real Af_r "To calulate reaction rate for forward reaction (Arrhenius constants of forward reaction)";
      input Real Ef_r "To calculate reaction rate for forward reaction";
      input Real T;
      
      output Real kf_r "reaction rate constants for forward reaction";
      
    algorithm
     
      kf_r := Af_r .* exp(-Ef_r/(8.314*T));
    
      
    end Arhenious;
