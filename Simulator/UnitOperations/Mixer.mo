within Simulator.UnitOperations;

model Mixer "Model of a mixer to mix multiple material streams"
  extends Simulator.Files.Icons.Mixer;
  import Simulator.Files.*;
  parameter ChemsepDatabase.GeneralProperties C[Nc] "Component instances array" annotation(
    Dialog(tab = "Mixer Specifications", group = "Component Parameters"));
  parameter Integer Nc "Number of components" annotation(
    Dialog(tab = "Mixer Specifications", group = "Component Parameters"));
  parameter Integer NI = 6 "Number of inlet streams" annotation(
    Dialog(tab = "Mixer Specifications", group = "Calculation Parameters"));
  
  Real Pin[NI](each unit = "Pa", each min = 0, each start = Pg) "Inlet stream pressure";
  Real xin_sc[NI, Nc](each unit = "-", each min = 0, each max = 1) "Inlet stream component mol fraction";
  Real Fin_s[NI](each unit = "mol/s", each min = 0, each start = Fg) "Inlet stream Molar Flow";
  Real Hin_s[NI](each unit = "kJ/kmol") "Inlet stream molar enthalpy";
  Real Tin_s[NI](each unit = "K", each min = 0, each start = Tg) "Inlet stream temperature";
  Real Sin_s[NI](each unit = "kJ/[kmol.K]") "Inlet stream molar entropy";
  Real xvapin_s[NI](each unit = "-", each min = 0, each max = 1, each start = xvapg) "Inlet stream vapor phase mol fraction";
  
  parameter String outPress "Calculation mode for outet pressure: ''Inlet_Minimum'', ''Inlet_Average'', ''Inlet_Maximum''" annotation(
    Dialog(tab = "Mixer Specifications", group = "Calculation Parameters"));
  
  Real Fout(unit = "mol/s", each min = 0, each start = Fg) "Outlet stream molar flow";
  Real Pout(unit = "Pa", min = 0, start = Pg) "Outlet stream pressure";
  Real Hout(unit = "kJ/kmol") "Outlet stream molar enthalpy";
  Real Tout(unit = "K", each min = 0, each start = Tg) "Outlet stream temperature";
  Real Sout(unit = "kJ/[kmol.K]") "Outlet stream molar entropy";
  Real xvapout(unit = "-", min = 0, max = 1, start = xvapg) "Outlet stream vapor phase mol fraction";
  Real xout_c[Nc](each unit = "-", each min = 0, each max = 1, start = xguess) "Outlet stream component mol fraction";
 //================================================================================
  //  Files.Interfaces.matConn inlet[NI](each Nc = Nc);
  Simulator.Files.Interfaces.matConn Out(Nc = Nc) annotation(
    Placement(visible = true, transformation(origin = {100, -2}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Simulator.Files.Interfaces.matConn In[NI](each Nc = Nc) annotation(
    Placement(visible = true, transformation(origin = {-100, -2}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  
  extends GuessModels.InitialGuess;
  
equation
//Connector equation
  for i in 1:NI loop
    In[i].P = Pin[i];
    In[i].T = Tin_s[i];
    In[i].F = Fin_s[i];
    In[i].H = Hin_s[i];
    In[i].S = Sin_s[i];
    In[i].x_pc[1, :] = xin_sc[i, :];
    In[i].xvap = xvapin_s[i];
  end for;
  Out.P = Pout;
  Out.T = Tout;
  Out.F = Fout;
  Out.H = Hout;
  Out.S = Sout;
  Out.x_pc[1, :] = xout_c[:];
  Out.xvap = xvapout;
//===================================================================================
//Output Pressure
  if outPress == "Inlet_Minimum" then
    Pout = min(Pin);
  elseif outPress == "Inlet_Average" then
    Pout = sum(Pin) / NI;
  elseif outPress == "Inlet_Maximum" then
    Pout = max(Pin);
  end if;
//Molar Balance
  Fout = sum(Fin_s[:]);
  for i in 1:Nc loop
    xout_c[i] * Fout = sum(xin_sc[:, i] .* Fin_s[:]);
  end for;
//Energy balance
  Hout = sum(Hin_s[:] .* Fin_s[:] / Fout);

annotation(
    Documentation(info = "<html>
  <p>The <b>Mixer</b> is used to mix up to any number of material streams into one, while executing all the mass and energy balances.</p>
  
    <p>The only calculation parameter for mixer is the outlet pressure calculation mode (<b>outPress</b>) variable which is of type <i>parameter String</i>. It can have either of the string values among the following modes:
    <ol>
    <li><b>Inlet_Minimum</b>: Outlet pressure is taken as minimum of all inlet streams pressure</li>
    <li><b>Inlet_Average</b>: Outlet pressure is calculated as average of all inlet streams pressure</li>
    <li><b>Inlet_Maximum</b>: Outlet pressure is taken as maximum of all inlet streams pressure</li>
    </ol>
   
   <div><b>outPress</b> has been declared of type <i>parameter String.&nbsp;</i></div>
    <div>During simulation, it can specified directly under <b>Mixer Specifications</b>by double clicking on the mixer model instance.</div></p>
<p>&nbsp;</p>
  <p>  For detailed explanation on how to use this model to simulate a Mixer, go to <a href=\"modelica://Simulator.Examples.Mixer\">Mixer Example</a></p>
    </html>"));
    end Mixer;
