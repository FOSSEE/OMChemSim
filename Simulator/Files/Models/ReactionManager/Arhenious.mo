within Simulator.Files.Models.ReactionManager;

function Arhenious
  // Reaction rate constant k = A*exp(-E/RT)
  input Integer Nr;
  input Real A1[Nr] "To calulate reaction rate for forward reaction (Arrhenius constants of forward reaction)";
  input Real E1[Nr] "To calculate reaction rate for forward reaction";
  input Real T;
  output Real k1[Nr] "reaction rate constants for forward reaction";
algorithm
  k1 := A1 .* exp(-E1 / (8.314 * T));
end Arhenious;
