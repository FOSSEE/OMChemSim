within Simulator.Test;

package cmpstms
  model ms
    extends Simulator.Streams.Material_Stream;
    extends Simulator.Files.Thermodynamic_Packages.Raoults_Law;
  end ms;

  model main
    //instance of database
    import data = Simulator.Files.Chemsep_Database;
    //instance of components
    parameter data.Benzene benz;
    parameter data.Toluene tol;
    //declaration of NOC and comp
    parameter Integer NOC = 2;
    parameter data.General_Properties comp[NOC] = {benz, tol};
    //instance of composite material stream
    Simulator.Test.cmpstms.ms ms1(NOC = NOC, comp = comp) annotation(
      Placement(visible = true, transformation(origin = {-50, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  equation
    ms1.P = 101325;
    ms1.T = 368;
    ms1.totMolFlo[1] = 100;
    ms1.compMolFrac[1, :] = {0.5, 0.5};
  end main;
end cmpstms;
