within Simulator.Test.Heat_Exchanger_test;

model MS
  extends Simulator.Streams.Material_Stream;
  //material stream extended
  extends Simulator.Files.Thermodynamic_Packages.Raoults_Law;
  //thermodynamic package Raoults law is extended
end MS;
