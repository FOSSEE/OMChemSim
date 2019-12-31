within Simulator.Examples;
  
package HeatExchanger
  //Model of a General Purpouse Heat Exchanger operating with multiple modes
  //================================================================================================================
  extends Modelica.Icons.ExamplesPackage;
  model MS
    extends Simulator.Streams.MaterialStream;
    //material stream extended
    extends Simulator.Files.ThermodynamicPackages.RaoultsLaw;
    //thermodynamic package Raoults law is extended
  end MS;

  model HX_Test
  extends Modelica.Icons.Example;
  import data = Simulator.Files.ChemsepDatabase;
    //instantiation of ethanol
    parameter data.Styrene sty;
    //instantiation of acetic acid
    parameter data.Toluene tol;
    parameter Integer Nc = 2;
    parameter data.GeneralProperties C[Nc] = {sty, tol};
    Simulator.UnitOperations.HeatExchanger HX(Cmode = "Outlet_Temparatures", Qloss = 0, Mode = "CounterCurrent", Nc = Nc, C = C, Pdelc = 0, Pdelh = 0) annotation(
      Placement(visible = true, transformation(origin = {-16, -2}, extent = {{-22, -22}, {22, 22}}, rotation = 0)));
    Simulator.Examples.HeatExchanger.MS In_Hot(Nc = Nc, C = C) annotation(
      Placement(visible = true, transformation(origin = {-86, 38}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Simulator.Examples.HeatExchanger.MS Out_Hot(Nc = Nc, C = C) annotation(
      Placement(visible = true, transformation(origin = {68, 70}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Simulator.Examples.HeatExchanger.MS In_Cold(Nc = Nc, C = C) annotation(
      Placement(visible = true, transformation(origin = {-22, 64}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Simulator.Examples.HeatExchanger.MS Out_Cold(Nc = Nc, C = C) annotation(
      Placement(visible = true, transformation(origin = {46, -48}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  equation
    connect(In_Hot.Out, HX.In_Hot) annotation(
      Line(points = {{-76, 38}, {-76, -2}, {-38, -2}}));
    connect(HX.Out_Hot, Out_Hot.In) annotation(
      Line(points = {{6, -2}, {6, 45}, {58, 45}, {58, 70}}));
    connect(HX.Out_Cold, Out_Cold.In) annotation(
      Line(points = {{-16, -24}, {-16, -48}, {36, -48}}));
    connect(In_Cold.Out, HX.In_Cold) annotation(
      Line(points = {{-12, 64}, {-12, 38}, {-16, 38}, {-16, 20}}));
    In_Hot.x_pc[1, :] = {1, 0};
    In_Cold.x_pc[1, :] = {0, 1};
    In_Hot.F_p[1] = 181.46776;
    In_Cold.F_p[1] = 170.93083;
    In_Hot.T = 422.03889;
    In_Cold.T = 310.92778;
    In_Hot.P = 344737.24128;
    In_Cold.P = 620527.03429;
    HX.U = 300;
    HX.Qact = 2700E03;
  end HX_Test;

  model HX_Design
  extends Modelica.Icons.Example;
  import data = Simulator.Files.ChemsepDatabase;
    
    parameter data.Water wat;
    parameter data.Noctane oct;
    parameter data.Nnonane non;
    parameter data.Ndecane dec;
    
    parameter Integer Nc = 4;
    parameter data.GeneralProperties C[Nc] = {wat,oct,non,dec};
    
    Simulator.UnitOperations.HeatExchanger HX( C = C,Cmode = "Design", Mode = "CounterCurrent", Nc = Nc, Pdelc = 0, Pdelh = 0, Qloss = 0) annotation(
      Placement(visible = true, transformation(origin = {-16, -2}, extent = {{-22, -22}, {22, 22}}, rotation = 0)));
    Simulator.Examples.HeatExchanger.MS In_Hot(Nc = Nc, C = C) annotation(
      Placement(visible = true, transformation(origin = {-86, 38}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Simulator.Examples.HeatExchanger.MS Out_Hot(Nc = Nc, C = C) annotation(
      Placement(visible = true, transformation(origin = {68, 70}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Simulator.Examples.HeatExchanger.MS In_Cold(Nc = Nc, C = C) annotation(
      Placement(visible = true, transformation(origin = {-22, 64}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Simulator.Examples.HeatExchanger.MS Out_Cold(Nc = Nc, C = C) annotation(
      Placement(visible = true, transformation(origin = {46, -48}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  
  equation
    connect(In_Hot.Out, HX.In_Hot) annotation(
      Line(points = {{-76, 38}, {-76, -2}, {-38, -2}}));
    connect(HX.Out_Hot, Out_Hot.In) annotation(
      Line(points = {{6, -2}, {6, 45}, {58, 45}, {58, 70}}));
    connect(HX.Out_Cold, Out_Cold.In) annotation(
      Line(points = {{-16, -24}, {-16, -48}, {36, -48}}));
    connect(In_Cold.Out, HX.In_Cold) annotation(
      Line(points = {{-12, 64}, {-12, 38}, {-16, 38}, {-16, 20}}));
    In_Hot.x_pc[1, :] = {0, 0,0.1,0.9};
    In_Cold.x_pc[1, :] = {1,0,0,0};
    In_Hot.F_p[1] =212.94371;
    In_Cold.F_p[1] = 3077.38424;
    In_Hot.T = 377.03889;
    In_Cold.T = 304.26111;
    In_Hot.P =1116948.66173;
    In_Cold.P = 606737.54464;
  end HX_Design;
end HeatExchanger;
