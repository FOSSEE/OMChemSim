within Simulator.Test.valve1;

model ms
  //This model will be instantiated in maintest model as outlet stream of valve. Dont run this model. Run maintest model for valve test
  extends Simulator.Streams.Material_Stream;
  //material stream extended
  extends Simulator.Files.Thermodynamic_Packages.Raoults_Law;
  //thermodynamic package Raoults law is extended
end ms;
