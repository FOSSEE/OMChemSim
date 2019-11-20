within Simulator.Examples;

package CompositeMS
  extends Modelica.Icons.ExamplesPackage;
  model ms
    extends Simulator.Streams.MaterialStream;
    extends Simulator.Files.ThermodynamicPackages.RaoultsLaw;
  end ms;

  model main
    extends Modelica.Icons.Example;
    //instance of database
    import data = Simulator.Files.ChemsepDatabase;
    //instance of components
    parameter data.Benzene benz;
    parameter data.Toluene tol;
    //declaration of NOC and comp
    parameter Integer Nc = 2;
    parameter data.GeneralProperties C[Nc] = {benz, tol};
    //instance of composite material stream
    Simulator.Examples.CompositeMS.ms ms1(Nc = Nc, C = C) annotation(
      Placement(visible = true, transformation(origin = {-79, -31}, extent = {{-11, -11}, {11, 11}}, rotation = 0)));
  equation
    ms1.P = 101325;
    ms1.T = 368;
    ms1.F_p[1] = 100;
    ms1.x_pc[1, :] = {0.5, 0.5};
  end main;
end CompositeMS;
