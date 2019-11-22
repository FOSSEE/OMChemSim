within Simulator.Files.Models.ReactionManager;

function Stoichiometrycheck
    extends Modelica.Icons.Function;
    //This functions checks the stoichiometry of the reaction we have given and returns "1" as output if the stoichiometry is okay and returns 0 otherwise.
    input Integer Nr"No. of Reactions";
    input Integer Nc"Nomber of components in the required reactions";
    input Real MW_c[Nc]"Molecular weight";
    input Real Sc_cr[Nc,Nr]"Reaction coefficients";
    output Integer Chk_r[Nr];
    
    protected
    Real D_r[Nr]=fill(0,Nr);
    
    algorithm
    for i in 1:Nr loop
      for j in 1:Nc loop
        D_r[i]:=D_r[i]+(MW_c[j]*Sc_cr[j,i]);
      end for;
      if D_r[i]<=0.1 and D_r[i]>=-0.1 then
      Chk_r[i]:=1;
      else 
      Chk_r[i]:=0;
      end if;
    end for;
    end Stoichiometrycheck;
    
