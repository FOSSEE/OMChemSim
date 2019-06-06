within Simulator.Test;

package PFR_Test
  model MS
    extends Simulator.Streams.Material_Stream;
    extends Simulator.Files.Thermodynamic_Packages.Raoults_Law;
  end MS;

  model PFR_Test_II
    //Advicable to select the first component as the base component
    // importing the thermodynamic data from chemsep database
    import data = Simulator.Files.Chemsep_Database;
    //instantiation of ethanol
    parameter data.Ethyleneoxide eth;
    //instantiation of acetic acid
    parameter data.Ethyleneglycol eg;
    //instantiation of water
    parameter data.Water wat;
    parameter Integer NOC = 3;
    parameter data.General_Properties comp[NOC] = {eth, wat, eg};
    // Instantiating the material stream model(as inlet and outlet) and also the model for PFR with connectors
    Simulator.Streams.Energy_Stream Energy annotation(
      Placement(visible = true, transformation(origin = {2, -36}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Simulator.Unit_Operations.PF_Reactor.PFR PFR(NOC = 3, Nr = 1, comp = {eth, wat, eg}, Mode = 2, Phase = 3, Tdef = 410) annotation(
      Placement(visible = true, transformation(origin = {8, 22}, extent = {{-38, -38}, {38, 38}}, rotation = 0)));
    MS Inlet(NOC = NOC, comp = comp) annotation(
      Placement(visible = true, transformation(origin = {-66, 8}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    MS Outlet(NOC = NOC, comp = comp) annotation(
      Placement(visible = true, transformation(origin = {86, 10}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  equation
    connect(Outlet.inlet, PFR.outlet) annotation(
      Line(points = {{76, 10}, {60.5, 10}, {60.5, 22}, {41, 22}}));
    connect(PFR.inlet, Inlet.outlet) annotation(
      Line(points = {{-22, 22}, {-56, 22}, {-56, 8}}));
    connect(Energy.inlet, PFR.en_Conn) annotation(
      Line(points = {{-8, -36}, {0, -36}, {0, 5}, {3, 5}}));
// Connection of PFR with inlet and outlet stream
// Giving values to the instantiated inlet material stream
//mixture molar composition
    Inlet.compMolFrac[1, :] = {0.2, 0.8, 0};
//input pressure
    Inlet.P = 101325;
//input temperature
    Inlet.T = 395;
// total moles of inlet stream
    Inlet.totMolFlo[1] = 100;
//Conversion of Base_component
    PFR.X[1] = 0.0741;
  end PFR_Test_II;
end PFR_Test;
