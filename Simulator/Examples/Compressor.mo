within Simulator.Examples;

package Compressor
  extends Modelica.Icons.ExamplesPackage;
  model ms
    //This model will be instantiated in adia_comp model as outlet stream of heater. Dont run this model. Run adia_comp model for test
    extends Simulator.Streams.MaterialStream;
    extends Simulator.Files.ThermodynamicPackages.RaoultsLaw;
  end ms;

  model compres
    extends UnitOperations.AdiabaticCompressor;
    extends Files.ThermodynamicPackages.RaoultsLaw;
  end compres;

  model main
    extends Modelica.Icons.Example;
    import data = Simulator.Files.ChemsepDatabase;
    //instantiation of chemsep database
    parameter data.Benzene ben;
    //instantiation of methanol
    parameter data.Toluene tol;
    //instantiation of ethanol
    parameter Integer Nc = 2;
    parameter data.GeneralProperties C[Nc] = {ben, tol};
    Simulator.Examples.Compressor.compres adiabatic_Compressor1(Nc = Nc, C = C, Eff = 0.75) annotation(
      Placement(visible = true, transformation(origin = {-17, 7}, extent = {{-15, -15}, {15, 15}}, rotation = 0)));
    Simulator.Examples.Compressor.ms inlet(Nc = Nc, C = C) annotation(
      Placement(visible = true, transformation(origin = {-78, 8}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    ms outlet(Nc = Nc, C = C) annotation(
      Placement(visible = true, transformation(origin = {58, 6}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Simulator.Streams.EnergyStream power annotation(
      Placement(visible = true, transformation(origin = {-50, -56}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  equation
  connect(inlet.Out, adiabatic_Compressor1.In) annotation(
      Line(points = {{-68, 8}, {-50, 8}, {-50, 17}, {-32, 17}}));
  connect(adiabatic_Compressor1.Out, outlet.In) annotation(
      Line(points = {{-2, 17}, {31, 17}, {31, 6}, {48, 6}}));
  connect(power.Out, adiabatic_Compressor1.En) annotation(
      Line(points = {{-40, -56}, {-17, -56}, {-17, 7}}));
    inlet.x_pc[1, :] = {0.5, 0.5};
//mixture molar composition
    inlet.P = 202650;
//input pressure
    inlet.T = 372;
//input temperature
    inlet.F_p[1] = 100;
//input molar flow
    adiabatic_Compressor1.Pdel = 10000;
//pressure increase
  end main;
end Compressor;
