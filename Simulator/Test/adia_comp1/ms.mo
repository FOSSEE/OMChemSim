within Simulator.Test.adia_comp1;

model ms
  //This model will be instantiated in adia_comp model as outlet stream of heater. Dont run this model. Run adia_comp model for test
  extends Simulator.Streams.Material_Stream;
  extends Simulator.Files.Thermodynamic_Packages.Raoults_Law;
end ms;
