within Simulator.Files.Models;

package ReactionManager
      function Stoichiometrycheck
    //This functions checks the stoichiometry of the reaction we have given and returns "1" as output if the stoichiometry is okay and returns 0 otherwise.
    input Integer Nr"No. of Reactions";
    input Integer NOC"Nomber of components in the required reactions";
    input Real MW[NOC]"Molecular weight";
    input Real Sc[NOC,Nr]"Reaction coefficients";
    output Integer Check[Nr];
    
    protected
    Real D[Nr]=fill(0,Nr);
    
    algorithm
    for i in 1:Nr loop
      for j in 1:NOC loop
        D[i]:=D[i]+(MW[j]*Sc[j,i]);
      end for;
      if D[i]<=0.1 and D[i]>=-0.1 then
      Check[i]:=1;
      else 
      Check[i]:=0;
      end if;
    end for;
    end Stoichiometrycheck;
    
    
    function Arhenious
    // Reaction rate constant k = A*exp(-E/RT)
          input Integer Nr ;    
      input Real A1[Nr] "To calulate reaction rate for forward reaction (Arrhenius constants of forward reaction)";
      input Real E1[Nr] "To calculate reaction rate for forward reaction";
      input Real T;
      
      output Real k1[Nr] "reaction rate constants for forward reaction";
      
    algorithm
     
      k1 := A1 .* exp(-E1/(8.314*T));
    
      
    end Arhenious;
    
    
       
    model Reaction_Manager
    //===================================================================================================
    import Simulator.Files.*;
    import data = Simulator.Files.Chemsep_Database;
    
    parameter Chemsep_Database.General_Properties comp[NOC];
    
    parameter Integer NOC;
    parameter Integer Nr;   //Number of Reactions involved in the process
    parameter Integer Bc[Nr]  "Base component of reactions";
    parameter Integer Comp;    
//Number of components involved in the reaction

    parameter Real Sc[NOC,Nr];  //Stochiometry of reactions
    parameter Real DO[NOC,Nr];  //Direct order of reactions
    parameter Real RO[NOC,Nr]; //Reverse order of reactions
    Real Stoic_Check[Nr];    

//Returns whether the specified stoichiometry is correct

    Real HOF_comp[NOC];
    Real HOR[Nr];
    
    parameter Real A1[Nr]"Arrhenius constants of forward reaction";
    parameter Real E1[Nr]"Activation Energy of the forward reaction";
    parameter Real A2[Nr]"Arrhenius constants of reverse reaction";
    parameter Real E2[Nr]"Activation Energy for the reverse reaction";
    
    equation

//Check of stoichiometric balance
          Stoic_Check = Stoichiometrycheck(Nr, NOC, comp[:].MW, Sc);
//Calculation of Heat of Reaction
          HOF_comp[:] = comp[:].IGHF .* 1E-3;
//=============================================================================================
          for i in 1:Nr loop
            HOR[i] = (sum(HOF_comp[:] .* Sc[:, i]))/Bc[i];
          end for;
    end Reaction_Manager;

//==============================================================================================
end ReactionManager;
