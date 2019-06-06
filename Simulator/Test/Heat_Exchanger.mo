within Simulator.Test;

package Heat_Exchanger
  //Model of a General Purpouse Heat Exchanger operating with multiple modes
  //================================================================================================================

  model MS
    extends Simulator.Streams.Material_Stream;
    //material stream extended
    extends Simulator.Files.Thermodynamic_Packages.Raoults_Law;
    //thermodynamic package Raoults law is extended
  end MS;

  model HX_Test
    import data = Simulator.Files.Chemsep_Database;
    //instantiation of ethanol
    parameter data.Styrene sty;
    //instantiation of acetic acid
    parameter data.Toluene tol;
    parameter Integer NOC = 2;
    parameter data.General_Properties comp[NOC] = {sty, tol};
    Simulator.Unit_Operations.Rigorous_HX HX(NOC = NOC, comp = comp, deltap_hot = 0, deltap_cold = 0, Heat_Loss = 0, Calculation_Method = "Outlet_Temparatures") annotation(
      Placement(visible = true, transformation(origin = {-2, 16}, extent = {{-22, -22}, {22, 22}}, rotation = 0)));
    Heat_Exchanger.MS Hot_In(NOC = NOC, comp = comp) annotation(
      Placement(visible = true, transformation(origin = {-58, 70}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Heat_Exchanger.MS Hot_Out(NOC = NOC, comp = comp) annotation(
      Placement(visible = true, transformation(origin = {66, 56}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Heat_Exchanger.MS Cold_In(NOC = NOC, comp = comp) annotation(
      Placement(visible = true, transformation(origin = {-76, -16}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Heat_Exchanger.MS Cold_Out(NOC = NOC, comp = comp) annotation(
      Placement(visible = true, transformation(origin = {50, -32}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  equation
    connect(Cold_In.outlet, HX.Cold_In) annotation(
      Line(points = {{-68, -16}, {-38, -16}, {-38, 10}, {-18, 10}}));
    connect(HX.Hot_Out, Hot_Out.inlet) annotation(
      Line(points = {{16, 24}, {58, 24}, {58, 56}}));
    connect(HX.Cold_Out, Cold_Out.inlet) annotation(
      Line(points = {{14, 10}, {15, 10}, {15, -32}, {42, -32}}));
    connect(Hot_In.outlet, HX.Hot_In) annotation(
      Line(points = {{-50, 70}, {-18, 70}, {-18, 24}}));
    Hot_In.compMolFrac[1, :] = {1, 0};
    Cold_In.compMolFrac[1, :] = {0, 1};
    Hot_In.totMolFlo[1] = 181.46776;
    Cold_In.totMolFlo[1] = 170.93083;
    Hot_In.T = 422.03889;
    Cold_In.T = 310.92778;
    Hot_In.P = 344737.24128;
    Cold_In.P = 620527.03429;
    HX.U = 300;
    HX.Qactual = 2700E03;
  end HX_Test;
end Heat_Exchanger;
