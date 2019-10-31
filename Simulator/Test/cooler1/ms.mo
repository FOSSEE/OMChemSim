within Simulator.Test.cooler1;

model ms
  //This model will be instantiated in maintest model as outlet stream of cooler. Dont run this model. Run maintest model for cooler test
  extends Simulator.Streams.Material_Stream(NOC = 2);
  //material stream extended
  extends Simulator.Files.Thermodynamic_Packages.Raoults_Law;
  //thermodynamic package Raoults law is extended
end ms;
