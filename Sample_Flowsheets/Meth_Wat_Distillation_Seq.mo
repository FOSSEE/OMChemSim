package Meth_Wat_Distillation_Seq

  model Material_Streams
    // //instantiation of chemsep database
    import data = Simulator.Files.Chemsep_Database;
    //instantiation of ethanol
    parameter data.Methanol meth;
    //instantiation of Acetic acid
    parameter data.Water wat;
    extends Simulator.Streams.Material_Stream(NOC = 2, comp = {meth, wat}, totMolFlo(each start = 1), compMolFrac(each start = 0.33), T(start = sum(comp.Tb) / NOC));
    //material stream extended in which parameter NOC and comp are given values and other variables are given start values
    extends Simulator.Files.Thermodynamic_Packages.Raoults_Law;
    //thermodynamic package Raoults law is extended
  end Material_Streams;

//Flowsheet: Methanol-Water Distillation
//Thermodynamic-Package:Raoults Law

model Flowsheet_Two
    import data = Simulator.Files.Chemsep_Database;
    //instantiation of Methanol
    parameter data.Methanol meth;
    //instantiation of Water
    parameter data.Water wat;
    //Number of Components
    parameter Integer NOC = 2;
    parameter data.General_Properties comp[NOC] = {meth, wat};
    Meth_Wat_Distillation_Seq.Material_Streams Input(NOC = NOC, comp = comp) annotation(
      Placement(visible = true, transformation(origin = {-108, 38}, extent = {{-8, -8}, {8, 8}}, rotation = 0)));
    Simulator.Unit_Operations.Heater Heater(pressDrop = 0, eff = 1, NOC = NOC, comp = comp) annotation(
      Placement(visible = true, transformation(origin = {-67, 37}, extent = {{-9, -9}, {9, 9}}, rotation = 0)));
    Meth_Wat_Distillation_Seq.Material_Streams Preheated_Feed(NOC = NOC, comp = comp, T(start = 353), compMolFrac(each start = 0.333), P(start = 101325)) annotation(
      Placement(visible = true, transformation(origin = {-22, 36}, extent = {{-6, -6}, {6, 6}}, rotation = 0)));
    Simulator.Streams.Energy_Stream Energy_I annotation(
      Placement(visible = true, transformation(origin = {-111, 5}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));
    Meth_Wat_Distillation_Seq.rigDist.DistColumn DC(NOC = NOC, comp = comp, noOfStages = 8, feedStages = {4}, each tray.liqMolFlo(each start = 100), each tray.vapMolFlo(each start = 150), each tray.T(start = 366)) annotation(
      Placement(visible = true, transformation(origin = {16, 36}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Meth_Wat_Distillation_Seq.Material_Streams Distillate(NOC = NOC, comp = comp) annotation(
      Placement(visible = true, transformation(origin = {102, 64}, extent = {{-6, -6}, {6, 6}}, rotation = 0)));
    Meth_Wat_Distillation_Seq.Material_Streams Bottoms(NOC = NOC, comp = comp, compMolFrac(each start = 0.5)) annotation(
      Placement(visible = true, transformation(origin = {63, 19}, extent = {{-7, -7}, {7, 7}}, rotation = 0)));
    Simulator.Streams.Energy_Stream C_Duty annotation(
      Placement(visible = true, transformation(origin = {68, 88}, extent = {{-6, -6}, {6, 6}}, rotation = 0)));
    Simulator.Streams.Energy_Stream R_duty annotation(
      Placement(visible = true, transformation(origin = {69, -25}, extent = {{7, -7}, {-7, 7}}, rotation = 0)));
    Simulator.Unit_Operations.Cooler Cooler(pressDrop = 0, eff = 1, NOC = 2, comp = {meth, wat}) annotation(
      Placement(visible = true, transformation(origin = {-38, -56}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Meth_Wat_Distillation_Seq.Material_Streams Outlet(NOC = NOC, comp = comp) annotation(
      Placement(visible = true, transformation(origin = {63, -53}, extent = {{-7, -7}, {7, 7}}, rotation = 0)));
    Simulator.Streams.Energy_Stream Energy_II annotation(
      Placement(visible = true, transformation(origin = {29, -85}, extent = {{-7, -7}, {7, 7}}, rotation = 0)));
  equation
  connect(DC.reboiler_duty, R_duty.inlet) annotation(
      Line(points = {{41, -24}, {57.5, -24}, {57.5, -25}, {76, -25}}));
  connect(Cooler.outlet, Outlet.inlet) annotation(
      Line(points = {{-28, -56}, {38, -56}, {38, -53}, {56, -53}}));
  connect(Distillate.outlet, Cooler.inlet) annotation(
      Line(points = {{108, 64}, {120, 64}, {120, -36}, {-104, -36}, {-104, -56}, {-48, -56}}, color = {0, 70, 70}));
  connect(Cooler.energy, Energy_II.inlet) annotation(
      Line(points = {{-28, -66}, {22, -66}, {22, -85}}, color = {255, 0, 0}));
    connect(DC.distillate, Distillate.inlet) annotation(
      Line(points = {{41, 65}, {96, 65}, {96, 64}}));
  connect(C_Duty.inlet, DC.condensor_duty) annotation(
      Line(points = {{62, 88}, {62, 93}, {44, 93}, {44, 98}}));
  connect(Energy_I.outlet, Heater.energy) annotation(
      Line(points = {{-106, 5}, {-76, 5}, {-76, 28}}));
  connect(Input.outlet, Heater.inlet) annotation(
      Line(points = {{-100, 38}, {-89, 38}, {-89, 37}, {-76, 37}}));
  connect(DC.bottoms, Bottoms.inlet) annotation(
      Line(points = {{41, 8}, {50, 8}, {50, 19}, {56, 19}}));
  connect(Preheated_Feed.outlet, DC.feed[1]) annotation(
      Line(points = {{-16, 36}, {-16, 34.5}, {-9, 34.5}, {-9, 30}}));
  connect(Heater.outlet, Preheated_Feed.inlet) annotation(
      Line(points = {{-58, 37}, {-40, 37}, {-40, 36}, {-28, 36}}));
  equation
//Design-Variables-
//// Molar Flow Rate of the outlet stream
// Outlet.totMolFlo[1] = 23.252;
// //Preheated Feed temperature
// Preheated_Feed.T = 325.15;
//The above two variables are specified as design variables to estimate the inlet temperature and inlet stream molar flow rate.
//Inlet mixture molar composition
    Input.compMolFrac[1, :] = {0.36, 0.64};
    Input.T = 300;
    Input.totMolFlo[1] = 60;
//Input pressure
    Input.P = 101325;
////Heat added
// Heater.tempInc = 25.15;
    Heater.outT = 325.15;
//Distillation Column
    DC.condensor.P = 101325;
    DC.reboiler.P = 101325;
//Reflux Ratio
    DC.refluxRatio = 2;
//Bottoms product molar flow rate
    Bottoms.totMolFlo[1] = 36.7475;
//Cooler Data
    Cooler.outT = 298;
  annotation(
      Diagram(coordinateSystem(extent = {{-150, -100}, {150, 100}})),
      Icon(coordinateSystem(extent = {{-150, -100}, {150, 100}})),
      __OpenModelica_commandLineOptions = "");end Flowsheet_Two;


//===============================================================================================

  package rigDist
    model Condensor
      extends Simulator.Unit_Operations.Distillation_Column.Cond;
      extends Simulator.Files.Thermodynamic_Packages.Raoults_Law;
    end Condensor;

    model Tray
      extends Simulator.Unit_Operations.Distillation_Column.DistTray;
      extends Simulator.Files.Thermodynamic_Packages.Raoults_Law;
    end Tray;

    model Reboiler
      extends Simulator.Unit_Operations.Distillation_Column.Reb;
      extends Simulator.Files.Thermodynamic_Packages.Raoults_Law;
    end Reboiler;

    model DistColumn
      extends Simulator.Unit_Operations.Distillation_Column.DistCol;
      Condensor condensor(NOC = NOC, comp = comp, boolFeed = boolFeed[1], condType = condType, T(start = 300));
      Reboiler reboiler(NOC = NOC, comp = comp, boolFeed = boolFeed[noOfStages]);
      Tray tray[noOfStages - 2](each NOC = NOC, each comp = comp, boolFeed = boolFeed[2:noOfStages - 1], each liqMolFlo(each start = 150), each vapMolFlo(each start = 150));
    end DistColumn;

  end rigDist;
end Meth_Wat_Distillation_Seq;
