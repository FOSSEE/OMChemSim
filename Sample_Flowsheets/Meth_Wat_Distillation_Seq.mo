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
      Placement(visible = true, transformation(origin = {-110, 36}, extent = {{-6, -6}, {6, 6}}, rotation = 0)));
    Simulator.Unit_Operations.Heater Heater(pressDrop = 0, eff = 1, NOC = NOC, comp = comp) annotation(
      Placement(visible = true, transformation(origin = {-66, 36}, extent = {{-28, -28}, {28, 28}}, rotation = 0)));
    Meth_Wat_Distillation_Seq.Material_Streams Preheated_Feed(NOC = NOC, comp = comp, T(start = 353), compMolFrac(each start = 0.333), P(start = 101325)) annotation(
      Placement(visible = true, transformation(origin = {-22, 36}, extent = {{-6, -6}, {6, 6}}, rotation = 0)));
    Simulator.Streams.Energy_Stream Energy_I annotation(
      Placement(visible = true, transformation(origin = {-87, 3}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));
    Meth_Wat_Distillation_Seq.rigDist.DistColumn DC(NOC = NOC, comp = comp, noOfStages = 8, feedStages = {4}, each tray.liqMolFlo(each start = 100), each tray.vapMolFlo(each start = 150), each tray.T(start = 366)) annotation(
      Placement(visible = true, transformation(origin = {20, 36}, extent = {{-24, -24}, {24, 24}}, rotation = 0)));
    Meth_Wat_Distillation_Seq.Material_Streams Distillate(NOC = NOC, comp = comp) annotation(
      Placement(visible = true, transformation(origin = {56, 54}, extent = {{-6, -6}, {6, 6}}, rotation = 0)));
    Meth_Wat_Distillation_Seq.Material_Streams Bottoms(NOC = NOC, comp = comp, compMolFrac(each start = 0.5)) annotation(
      Placement(visible = true, transformation(origin = {63, 19}, extent = {{-7, -7}, {7, 7}}, rotation = 0)));
    Simulator.Streams.Energy_Stream C_Duty annotation(
      Placement(visible = true, transformation(origin = {52, 72}, extent = {{-6, -6}, {6, 6}}, rotation = 0)));
    Simulator.Streams.Energy_Stream R_duty annotation(
      Placement(visible = true, transformation(origin = {50, -10}, extent = {{-6, -6}, {6, 6}}, rotation = 0)));
    Simulator.Unit_Operations.Cooler Cooler(pressDrop = 0, eff = 1, NOC = 2, comp = {meth, wat}) annotation(
      Placement(visible = true, transformation(origin = {-4, -52}, extent = {{-24, -24}, {24, 24}}, rotation = 0)));
    Meth_Wat_Distillation_Seq.Material_Streams Outlet(NOC = NOC, comp = comp) annotation(
      Placement(visible = true, transformation(origin = {61, -53}, extent = {{-7, -7}, {7, 7}}, rotation = 0)));
    Simulator.Streams.Energy_Stream Energy_II annotation(
      Placement(visible = true, transformation(origin = {-23, -89}, extent = {{-7, -7}, {7, 7}}, rotation = 0)));
  equation
  connect(Distillate.outlet, Cooler.inlet) annotation(
      Line(points = {{62, 54}, {166, 54}, {166, -34}, {-84, -34}, {-84, -52}, {-28, -52}, {-28, -52}}));
  connect(Energy_II.inlet, Cooler.energy) annotation(
      Line(points = {{-30, -89}, {-56, -89}, {-56, -74}, {-4, -74}, {-4, -76}}));
  connect(Cooler.outlet, Outlet.inlet) annotation(
      Line(points = {{20, -52}, {37, -52}, {37, -53}, {54, -53}}));
    connect(Energy_I.outlet, Heater.energy) annotation(
      Line(points = {{-82, 3}, {-66, 3}, {-66, 9}}));
    connect(DC.reboiler_duty, R_duty.inlet) annotation(
      Line(points = {{37, 12}, {44, 12}, {44, -10}}));
    connect(DC.bottoms, Bottoms.inlet) annotation(
      Line(points = {{44, 19}, {56, 19}}));
    connect(DC.distillate, Distillate.inlet) annotation(
      Line(points = {{44, 53}, {49, 53}, {49, 54}, {50, 54}}));
    connect(C_Duty.inlet, DC.condensor_duty) annotation(
      Line(points = {{46, 72}, {46, 57.5}, {34, 57.5}, {34, 59}}));
    connect(Preheated_Feed.outlet, DC.feed[1]) annotation(
      Line(points = {{-16, 36}, {-16, 34.5}, {-4, 34.5}, {-4, 35}}));
    connect(Heater.outlet, Preheated_Feed.inlet) annotation(
      Line(points = {{-38, 35}, {-28, 35}, {-28, 36}}));
    connect(Input.outlet, Heater.inlet) annotation(
      Line(points = {{-104, 36}, {-94, 36}}));
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
  end Flowsheet_Two;


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
