within Simulator.Files.Models.ReactionManager;

function BaseCalc
//This function is used to detect the base component of the stream
extends Modelica.Icons.Function;
input Integer Nc"Numner of components";
input Real F[Nc]"Stream flow rate";
input Real Sc[Nc]"Stoichiometric coefficient of the model";
output Integer N"Component index of the result check";

protected
Real v1;
Real v2;

algorithm

for i in 1:Nc loop
 if Sc[i]<0 then
 N:=i;
 break;
 else
 i:=i;
 end if;
end for;

v1:=F[N]/abs(Sc[N]);
 
for i in 1:Nc loop
if Sc[i]<0 then
 v2:=F[i]/abs(Sc[i]);
if v2<v1 then
 N:=i;
 v1:=v2;
 else
 i:=i;
 end if;
 else
  i:=i;
  end if;
  end for;
end BaseCalc;
