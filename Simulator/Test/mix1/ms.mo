within Simulator.Test.mix1;

model ms
  //This model will be instantiated in maintest model as material streams
  extends Simulator.Streams.Material_Stream;
  //material stream extended
  extends Simulator.Files.Thermodynamic_Packages.Raoults_Law;
  //thermodynamic package Raoults law is extended
end ms;
