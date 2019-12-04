within Simulator.Examples;

package CSTR
extends Modelica.Icons.ExamplesPackage;
model MS
  import data = Simulator.Files.ChemsepDatabase;
  parameter data.Ethyleneoxide e;
  parameter data.Water w;
  parameter data.Ethyleneglycol eg;
  extends Simulator.Streams.MaterialStream(Nc = 3, C = {e,w,eg});
  //material stream extended
  extends Simulator.Files.ThermodynamicPackages.RaoultsLaw;
  //thermodynamic package Raoults law is extended

end MS;

model Iso_Liq

//***** Phase Represents Reaction Phase in which the reaction takes place *****\\
  //***** Phase - 1 ---> Mixture, Phase - 2 ---> Liquid, Phase - 3 ---> Vapor *****\\
  //***** Volume of the Reactor should be specified in "Liters" *****\\
  //============================================================
  //Header Files and Packages
  import data = Simulator.Files.ChemsepDatabase;
parameter data.Ethyleneoxide e;
parameter data.Water w;
parameter data.Ethyleneglycol eg;
parameter data.GeneralProperties C[Nc] = {e, w, eg};
parameter Integer Nc = 3;
extends Modelica.Icons.Example;

//=============================================================
  //Instantiation of Streams and Blocks
 
  Simulator.UnitOperations.CSTR B1(C = C, Mode = 1, Nc = Nc, Pdel = 0, Phase = 2, V = 1000, xout_pc(start = {{0,0.33,0.67},{0,0.33,0.67},{0,0,0}}))  annotation(
    Placement(visible = true, transformation(origin = {2, 2.22045e-15}, extent = {{-24, -24}, {24, 24}}, rotation = 0)));
  MS S1(C = C, Nc = Nc)  annotation(
    Placement(visible = true, transformation(origin = {-70, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  MS S2(C = C, Nc = Nc)  annotation(
    Placement(visible = true, transformation(origin = {72, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
//==============================================================
//Connector Equation
equation
  connect(B1.Out, S2.In) annotation(
    Line(points = {{26, 0}, {62, 0}, {62, 0}, {62, 0}}, color = {0, 70, 70}));
  connect(S1.Out, B1.In) annotation(
    Line(points = {{-60, 0}, {-20, 0}, {-20, 0}, {-22, 0}}, color = {0, 70, 70}));

//==============================================================
//Specification
  S1.x_pc[1, :] = {0.4, 0.6, 0};
  S1.P = 101325;
  S1.T = 350;
  S1.F_p[1] = 100;
end Iso_Liq;

model Test_Tdef_M

//***** Phase Represents Reaction Phase in which the reaction takes place *****\\
//***** Phase - 1 ---> Mixture, Phase - 2 ---> Liquid, Phase - 3 ---> Vapor *****\\
//***** Volume of the Reactor should be specified in "Liters" *****\\
//============================================================
//Header Files and Packages
  import data = Simulator.Files.ChemsepDatabase;
  parameter data.Ethyleneoxide e;
  parameter data.Water w;
  parameter data.Ethyleneglycol eg;
  parameter data.GeneralProperties C[Nc] = {e, w, eg};
  parameter Integer Nc = 3;
  extends Modelica.Icons.Example;
  
//=============================================================
  //Instantiation of Streams and Blocks
  Simulator.Examples.CSTR.MS ms1(C = C, Nc = Nc)  annotation(
    Placement(visible = true, transformation(origin = {-78, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Simulator.UnitOperations.CSTR mfr1(C = C, Mode = 2, Nc = Nc, Phase = 1, Tdef = 370, VHspace = 0)  annotation(
    Placement(visible = true, transformation(origin = {0, 1.77636e-15}, extent = {{-18, -18}, {18, 18}}, rotation = 0)));
  Simulator.Examples.CSTR.MS ms2(C = C, Nc = Nc, T(start = 370))  annotation(
    Placement(visible = true, transformation(origin = {66, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

equation
  connect(ms1.Out, mfr1.In) annotation(
      Line(points = {{-68, 0}, {-18, 0}}, color = {0, 70, 70}));
  connect(mfr1.Out, ms2.In) annotation(
      Line(points = {{18, 0}, {56, 0}}, color = {0, 70, 70}));
//==============================================================
//Connector Equation
//==============================================================
//Specification
    ms1.x_pc[1, :] = {0.4, 0.6, 0};
  ms1.P = 101325;
  ms1.T = 350;
  ms1.F_p[1] = 100;
  mfr1.V = 1;
end Test_Tdef_M;

model Adia_Mix
  //***** Phase Represents Reaction Phase in which the reaction takes place *****\\
  //***** Phase - 1 ---> Mixture, Phase - 2 ---> Liquid, Phase - 3 ---> Vapor *****\\
  //***** Volume of the Reactor should be specified in "Liters" *****\\
 
  //============================================================
  //Header Files and Packages
  import data = Simulator.Files.ChemsepDatabase;
  parameter data.Ethyleneoxide e;
  parameter data.Water w;
  parameter data.Ethyleneglycol eg;
  parameter data.GeneralProperties C[Nc] = {e, w, eg};
  parameter Integer Nc = 3;
  extends Modelica.Icons.Example;
  //=============================================================
  //Instantiation of Streams and Blocks
  MS S1(Nc = Nc, C = C, x_pc(each min = 0.01, each max = 1, start = {{0.4, 0.6, 0}, {0.26812398, 0.73817602, 0}, {0.92305584, 0.076944162, 0}}), F_p(each start = 50), T(start = 350)) annotation(
    Placement(visible = true, transformation(origin = {-64, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Simulator.UnitOperations.CSTR B1(Pdel = 0, Mode = 3, Nc = Nc, Phase = 1, V = 2, T(start = 393.233), xvap(start = 0.854599), C = C, xout_pc(start = {{0.32,0.55,0.13},{0.02,0.3,0.68},{0.37,0.59,0.04}})) annotation(
    Placement(visible = true, transformation(origin = {-5, -1}, extent = {{-19, -19}, {19, 19}}, rotation = 0)));
  MS S2(Nc = Nc, C = C, T(start = 393.233), xvap(start = 0.854599), x_pc(start = {{0.32,0.55,0.13},{0.02,0.3,0.68},{0.37,0.59,0.04}})) annotation(
    Placement(visible = true, transformation(origin = {55, -1}, extent = {{-9, -9}, {9, 9}}, rotation = 0)));

//==============================================================
 //Connector Equation
equation
  connect(B1.Out, S2.In) annotation(
    Line(points = {{14, 0}, {28, 0}, {28, -1}, {46, -1}}, color = {0, 70, 70}));
  connect(S1.Out, B1.In) annotation(
    Line(points = {{-54, 0}, {-24, 0}, {-24, 0}, {-24, 0}}, color = {0, 70, 70}));
//==============================================================
//Specification
  S1.x_pc[1, :] = {0.4, 0.6, 0};
  S1.P = 101325;
  S1.T = 350;
  S1.F_p[1] = 100;
end Adia_Mix;

end CSTR;
