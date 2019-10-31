within Simulator.Guess_Models;

model Guess_Input
  //parameter Real Press = Modelica.Utilities.Examples.readRealParameter(file, "P");
  //parameter Real x1 =    Modelica.Utilities.Examples.readRealParameter(file, "x1");
  //parameter Real x2 =    Modelica.Utilities.Examples.readRealParameter(file, "x2");
  //parameter Real x3 =    Modelica.Utilities.Examples.readRealParameter(file, "x3");
  //parameter Real Feed_flow= Modelica.Utilities.Examples.readRealParameter(file, "F");
  //parameter Real T_input=Modelica.Utilities.Examples.readRealParameter(file, "T");
  //parameter Real CompMolFrac[NOC] = {x1,x2,x3};
  //parameter String file ="D:/data01.txt";
  parameter Real Press = 101325;
  parameter Real T_input = 300;
  parameter Real Feed_flow = 100;
  parameter Real CompMolFrac[NOC] = {0.33, 0.33, 0.34};
equation

end Guess_Input;
