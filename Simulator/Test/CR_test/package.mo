within Simulator.Test;

package CR_test
  model ms
    extends Simulator.Streams.Material_Stream;
    extends Simulator.Files.Thermodynamic_Packages.NRTL;
  end ms;

  model test
    import data = Simulator.Files.Chemsep_Database;
    parameter Integer NOC = 4;
    parameter data.Ethylacetate etac;
    parameter data.Water wat;
    parameter data.Aceticacid aa;
    parameter data.Ethanol eth;
    parameter data.General_Properties comp[NOC] = {etac, wat, aa, eth};
    conv_react cr(NOC = NOC, comp = comp, Nr = 1, Bc = {3}, Sc = {{1}, {1}, {-1}, {-1}}, X = {0.3}, calcMode = "Define_Outlet_Temperature", Tdef = 300) annotation(
      Placement(visible = true, transformation(origin = {11, -7}, extent = {{-29, -29}, {29, 29}}, rotation = 0)));
    CR_test.ms feed(NOC = NOC, comp = comp) annotation(
      Placement(visible = true, transformation(origin = {-83, -5}, extent = {{-13, -13}, {13, 13}}, rotation = 0)));
    CR_test.ms product(NOC = NOC, comp = comp) annotation(
      Placement(visible = true, transformation(origin = {88, -6}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  equation
    connect(cr.outlet, product.inlet) annotation(
      Line(points = {{32, -6}, {78, -6}}));
    connect(feed.outlet, cr.inlet) annotation(
      Line(points = {{-70, -6}, {-8, -6}, {-8, -6}, {-10, -6}}));
    feed.P = 101325;
    feed.T = 300;
    feed.compMolFrac[1, :] = {0, 0, 0.4, 0.6};
    feed.totMolFlo[1] = 100;
  end test;

  model conv_react
    extends Simulator.Unit_Operations.Conversion_Reactor;
    extends Simulator.Files.Models.ReactionManager.Reaction_Manager;
  end conv_react;
end CR_test;
