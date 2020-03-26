within Simulator.Files.Models.ReactionManager;

model EquilibriumReaction "Model of an equilibrium reaction used in equilibrium reactor"
  //===================================================================================================
  import Simulator.Files.*;
  import data = Simulator.Files.ChemsepDatabase;

  parameter Integer Nr "Number of reactions" annotation(
    Dialog(tab = "Reactor Specifications", group = "Calculation Parameters"));
  parameter Real Coef_cr[Nc, Nr] "Stoichiometric coefficient of components" annotation(
    Dialog(tab = "Reactions", group = "Equilibrium Reaction Parameters"));
  parameter String Rmode = "ConstantK" "Mode of specifying equilibrium constant: ConstantK, Tempfunc" annotation(
    Dialog(tab = "Reactions", group = "Equilibrium Reaction Parameters"));
  parameter Real Kg[Nr] "Equilibrium Constant, applicable if ConstantK is chosen in Rmode" annotation(
    Dialog(tab = "Reactions", group = "Equilibrium Reaction Parameters"));
  parameter Real A[Nr,4] "Coefficient of A in equation logk =(A1 + A2*T + A3*T^2 + A4*logT)/(B1 + B2*T + B3*T^2 + B4*logT), applicable if Tempfunc is chosen in Rmode" annotation(
    Dialog(tab = "Reactions", group = "Equilibrium Reaction Parameters"));
  parameter Real B[Nr,4] "Coefficient of B in equation logk =(A1 + A2*T + A3*T^2 + A4*logT)/(B1 + B2*T + B3*T^2 + B4*logT), applicable if Tempfunc is chosen in Rmode" annotation(
    Dialog(tab = "Reactions", group = "Equilibrium Reaction Parameters"));
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
    Icon(coordinateSystem(initialScale = 0)),
    Documentation(info = "<html><head></head><body><div>The <b>Equilibrium Reaction</b>&nbsp;defined is used in the equilibrium reactor for the following purposes:</div><div><ul><li>Check if the stoichiometry specified for the reaction is balanced</li><li>Calculate the heat of formation</li><li>Calculate the heat of reaction</li></ul></div><div><br></div>In an equilibrium reaction model, following calculation parameters are defined:<div><ol><li>Number of Reactions (<b>Nr</b>)</li><li>Stoichiometric Coefficient of Components in Reaction (<b>Coef_cr</b>)</li><li>Mode of specifying Equilibrium Constant (<b>Rmode</b>)</li><li>Equilibrium Constant (<b>Kg</b>) (<!--StartFragment--><span style=\"font-size: 12px;\">If Equilibrium Constant mode is ConstantK</span>)</li><li>Temperature function coefficients (<b>A</b> and <b>B</b>)&nbsp;(<span style=\"font-size: 12px;\">If Equilibrium Constant mode is Tempfunc</span>)</li></ol><div><div style=\"font-size: 12px; orphans: 2; widows: 2;\"><span style=\"orphans: auto; widows: auto;\">All the above variables are of type <i>parameter Real </i>except Mode of specifying Equilibrium Constant (<b>Rmode</b>) which&nbsp;</span><span style=\"orphans: auto; widows: auto;\">is of type&nbsp;</span><i style=\"orphans: auto; widows: auto;\">parameter String</i><span style=\"orphans: auto; widows: auto;\">. It can have either of the sting values among following:</span></div><!--StartFragment--><div style=\"font-size: 12px; orphans: 2; widows: 2;\"><ol><li><b>ConstantK</b>: If the equilibrium constant is defined directly</li><li><b>Tempfunc</b>: If the equilibrium constant is to be calculated from given function of temperature</li></ol></div><!--EndFragment--><div style=\"font-size: 12px; orphans: 2; widows: 2;\"><br></div><div style=\"font-size: 12px; orphans: 2; widows: 2;\">During simulation, their values can specified directly under&nbsp;<b>Reactions </b>tab<b>&nbsp;</b>by double clicking on the reactor model instance.</div></div></div><div style=\"font-size: 12px; orphans: 2; widows: 2;\"><br></div><div style=\"font-size: 12px; orphans: 2; widows: 2;\"><br></div><div><br></div></body></html>"));
end EquilibriumReaction;
