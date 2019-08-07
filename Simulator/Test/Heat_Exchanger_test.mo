within Simulator.Test;

package Heat_Exchanger_test
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
    Simulator.Unit_Operations.Heat_Exchanger HX( Calculation_Method = "Outlet_Temparatures", Heat_Loss = 0, Mode = "CounterCurrent",NOC = NOC, comp = comp, deltap_cold = 0, deltap_hot = 0) annotation(
      Placement(visible = true, transformation(origin = {-12, 18}, extent = {{-22, -22}, {22, 22}}, rotation = 0)));
    Simulator.Test.Heat_Exchanger_test.MS Hot_In(NOC = NOC, comp = comp) annotation(
      Placement(visible = true, transformation(origin = {-84, 36}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Simulator.Test.Heat_Exchanger_test.MS Hot_Out(NOC = NOC, comp = comp) annotation(
      Placement(visible = true, transformation(origin = {68, 70}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Simulator.Test.Heat_Exchanger_test.MS Cold_In(NOC = NOC, comp = comp) annotation(
      Placement(visible = true, transformation(origin = {-22, 64}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Simulator.Test.Heat_Exchanger_test.MS Cold_Out(NOC = NOC, comp = comp) annotation(
      Placement(visible = true, transformation(origin = {46, -48}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  equation
  connect(HX.Cold_Out, Cold_Out.inlet) annotation(
      Line(points = {{-12, -4}, {-12, -48}, {36, -48}}));
  connect(HX.Hot_Out, Hot_Out.inlet) annotation(
      Line(points = {{10, 18}, {10, 45}, {58, 45}, {58, 70}}));
  connect(Hot_In.outlet, HX.Hot_In) annotation(
      Line(points = {{-74, 36}, {-74, 18}, {-34, 18}}));
  connect(Cold_In.outlet, HX.Cold_In) annotation(
      Line(points = {{-12, 64}, {-12, 40}}));
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
end Heat_Exchanger_test;
