within Simulator.Test.heater1;

model ms
  extends Simulator.Streams.Material_Stream;
  //material stream extended
  extends Simulator.Files.Thermodynamic_Packages.Raoults_Law;
  //thermodynamic package Raoults law is extended
end ms;
