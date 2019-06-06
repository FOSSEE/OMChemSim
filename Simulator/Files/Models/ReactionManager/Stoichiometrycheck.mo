within Simulator.Files.Models.ReactionManager;

function Stoichiometrycheck
  //This functions checks the stoichiometry of the reaction we have given and returns "1" as output if the stoichiometry is okay and returns 0 otherwise.
  input Integer Nr "No. of Reactions";
  input Integer NOC "Nomber of components in the required reactions";
  input Real MW[NOC] "Molecular weight";
  input Real Sc[NOC, Nr] "Reaction coefficients";
  output Integer Check[Nr];
protected
  Real D[Nr] = fill(0, Nr);
algorithm
  for i in 1:Nr loop
    for j in 1:NOC loop
      D[i] := D[i] + MW[j] * Sc[j, i];
    end for;
    if D[i] <= 0.1 and D[i] >= (-0.1) then
      Check[i] := 1;
    else
      Check[i] := 0;
    end if;
  end for;
end Stoichiometrycheck;
