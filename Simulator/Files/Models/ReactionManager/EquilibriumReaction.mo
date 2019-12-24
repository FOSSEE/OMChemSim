within Simulator.Files.Models.ReactionManager;

model EquilibriumReaction
  //===================================================================================================
  import Simulator.Files.*;
  import data = Simulator.Files.ChemsepDatabase;

  parameter Integer Nr;
  //Number of Reactions involved in the process
  parameter Real Coef_cr[Nc, Nr];
  parameter String Rmode;
  parameter Real Kg[Nr];
  parameter Real A[Nr,4];
  parameter Real B[Nr,4];
   Real T;
  //Stochiometry of reactions
  Real Schk_r[Nr];
  //Returns whether the specified stoichiometry is correct
  Real Hf_c[Nc];
  Real Hr_r[Nr];

  
  //Equilibrium Constant
  Real K[Nr](start=xliqg);
  Real N[Nr](each start= Fg),D[Nr](each start=Fg);
  
  extends Simulator.GuessModels.InitialGuess;
equation
 

//Check of stoichiometric balance
  Schk_r = Simulator.Files.Models.ReactionManager.Stoichiometrycheck(Nr, Nc, C[:].MW, Coef_cr);
//Calculation of Heat of Reaction
  Hf_c[:] = C[:].IGHF .* 1E-3;
//=============================================================================================
  for i in 1:Nr loop
    Hr_r[i] = sum(Hf_c[:] .* Coef_cr[:, i])/(Coef_cr[BC_r[1],i]);
  end for;

if(Rmode=="ConstantK") then
 K = Kg;
 for i in 1:Nr loop
 N[i] =0;
 D[i]=0;
 end for; 
elseif(Rmode=="Tempfunc") then
 for i in 1:Nr loop
 N[i] = (A[i,1]+A[i,2]*T+A[i,3]*T^2+A[i,4]*log(T));
 D[i] = (B[i,1]+B[i,2]*T+B[i,3]*T^2+B[i,4]*log(T));
end for; 
(K)= exp(N./D);
end if;  

annotation(
    Icon(coordinateSystem(initialScale = 0)));
end EquilibriumReaction;
