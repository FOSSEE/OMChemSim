within Simulator.Test.comp_sep1;

model ms
  extends Simulator.Streams.Material_Stream(NOC = 2, comp = {benz, tol});
  extends Simulator.Files.Thermodynamic_Packages.Raoults_Law;
end ms;
