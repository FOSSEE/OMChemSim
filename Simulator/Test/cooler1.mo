within Simulator.Test;

package cooler1
  model ms
    //This model will be instantiated in maintest model as outlet stream of cooler. Dont run this model. Run maintest model for cooler test
    extends Simulator.Streams.Material_Stream(NOC = 2);
    //material stream extended
    extends Simulator.Files.Thermodynamic_Packages.Raoults_Law;
    //thermodynamic package Raoults law is extended
  end ms;

  model cool
    //use non linear solver hybrid to simulate this model
    import data = Simulator.Files.Chemsep_Database;
    //instantiation of chemsep database
    parameter data.Methanol meth;
    //instantiation of methanol
    parameter data.Ethanol eth;
    //instantiation of ethanol
    parameter data.Water wat;
    //instantiation of water
    Unit_Operations.Cooler cooler1(pressDrop = 0, eff = 1, NOC = 3, comp = {meth, eth, wat}) annotation(
      Placement(visible = true, transformation(origin = {-4, 18}, extent = {{-14, -14}, {14, 14}}, rotation = 0)));
    ms inlet(NOC = 3, comp = {meth, eth, wat}) annotation(
      Placement(visible = true, transformation(origin = {-72, 18}, extent = {{-12, -12}, {12, 12}}, rotation = 0)));
    ms outlet(NOC = 3, comp = {meth, eth, wat}, T(start = 352.6146), compMolFrac(start = {{0.33, 0.33, 0.34}, {0.27, 0.32, 0.39}, {0.48, 0.33, 0.18}}), P(start = 101325)) annotation(
      Placement(visible = true, transformation(origin = {58, 18}, extent = {{-12, -12}, {12, 12}}, rotation = 0)));
    Streams.Energy_Stream energy annotation(
      Placement(visible = true, transformation(origin = {33, -43}, extent = {{-13, -13}, {13, 13}}, rotation = 0)));
  equation
    connect(cooler1.energy, energy.inlet) annotation(
      Line(points = {{-4, 4}, {-4, 4}, {-4, -44}, {20, -44}, {20, -44}}));
    connect(cooler1.outlet, outlet.inlet) annotation(
      Line(points = {{10, 18}, {44, 18}, {44, 18}, {46, 18}}));
    connect(inlet.outlet, cooler1.inlet) annotation(
      Line(points = {{-60, 18}, {-20, 18}, {-20, 18}, {-18, 18}}));
  equation
    inlet.compMolFrac[1, :] = {0.33, 0.33, 0.34};
//mixture molar composition
    inlet.P = 101325;
//input pressure
    inlet.T = 353;
//input temperature
    inlet.totMolFlo[1] = 100;
//input molar flow
    cooler1.heatRem = 200000;
//heat removed
  end cool;
end cooler1;
