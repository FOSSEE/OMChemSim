within Simulator.Test;

package CSTR_Test

model Test_L
  //Phase 1 -- Mixture, Phase 2 -- Liquid, Phase 3 -- Vapor
  //If Phase is 1 or 3 specify the headspace
  import data = Simulator.Files.Chemsep_Database;
  parameter data.Ethyleneoxide e;
  parameter data.Water w;
  parameter data.Ethyleneglycol eg;
  parameter data.General_Properties comp[NOC] = {e, w, eg};
  parameter Integer NOC = 3;
   
  MS ms1(NOC = NOC, comp = comp, compMolFrac(each min = 0.01, each max = 1, start = {{0.4, 0.6, 0}, {0.26812398, 0.73817602, 0}, {0.92305584, 0.076944162, 0}}), totMolFlo(each start = 50)) annotation(
    Placement(visible = true, transformation(origin = {-78, -8}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  
  Simulator.Unit_Operations.CSTR mfr1(NOC = NOC, comp = comp, Mode = 1, pressDrop = 0, Phase = 2, V_HS = 100) annotation(
    Placement(visible = true, transformation(origin = {3, -9}, extent = {{-25, -25}, {25, 25}}, rotation = 0)));
  
  MS ms2(NOC = NOC, comp = comp,compMolFrac(each min = 0.01, each max = 1, start = {{0.67,0.33,0},{0.67,0.33,0},{0,0,0}}))
  annotation(Placement(visible = true, transformation(origin = {67, -7}, extent = {{-9, -9}, {9, 9}}, rotation = 0)));
equation
  connect(mfr1.Liquid, ms2.inlet) annotation(
    Line(points = {{12, -8}, {58, -8}, {58, -6}, {58, -6}}, color = {0, 70, 70}));
  connect(ms1.outlet, mfr1.Feed) annotation(
    Line(points = {{-68, -8}, {-22, -8}, {-22, -4}, {-20, -4}}, color = {0, 70, 70}));
  ms1.compMolFrac[1, :] = {0.4, 0.6, 0};
  ms1.P = 101325;
  ms1.T = 350;
  ms1.totMolFlo[1] = 100;
  mfr1.V = 100;

end Test_L;











model MS
  import data = Simulator.Files.Chemsep_Database;
  parameter data.Ethyleneoxide e;
  parameter data.Water w;
  parameter data.Ethyleneglycol eg;
  extends Simulator.Streams.Material_Stream(NOC = 3, comp = {e,w,eg});
  //material stream extended
  extends Simulator.Files.Thermodynamic_Packages.Raoults_Law;
  //thermodynamic package Raoults law is extended

end MS;

model Test_M
  //Phase 1 -- Mixture
  //Phase 2 -- Liquid
  //Phase 3 -- Vapor
  // If Phase is 1 or 3 specify the headspace
  import data = Simulator.Files.Chemsep_Database;
  parameter data.Ethyleneoxide e;
  parameter data.Water w;
  parameter data.Ethyleneglycol eg;
  parameter data.General_Properties comp[NOC] = {e, w, eg};
  parameter Integer NOC = 3;
  
 MS ms1(NOC = NOC, comp = comp, compMolFrac(each min = 0.01, each max = 1, start = {{0.4,0.6,0},{0.26812398,0.73817602,0},{0.92305584,0.076944162,0}}), totMolFlo(each start = 50),T(start = 350))annotation(Placement(visible = true, transformation(origin = {-58, -4}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));  
 
 Simulator.Unit_Operations.CSTR mfr1(NOC = NOC, comp = comp, Mode = 1,  pressDrop = 0,  Phase = 1, V_HS = 1000) annotation(Placement(visible = true, transformation(origin = {3, -9}, extent = {{-25, -25}, {25, 25}}, rotation = 0)));
  
 MS ms2(NOC = NOC, comp = comp, compMolFrac(each min = 0.01, each max = 1, start = {{0.31484955,0.54323303,0.14191742},{0.0896477,0.68927029,0.22108201},{0.71505164,0.28371289,0.0012354724}}),T(start = 350,fixed = true))
 
   annotation(Placement(visible = true, transformation(origin = {49, -7}, extent = {{-9, -9}, {9, 9}}, rotation = 0))); equation
  connect(mfr1.Liquid, ms2.inlet) annotation(
    Line(points = {{12, -8}, {40, -8}, {40, -6}, {40, -6}}, color = {0, 70, 70}));
  connect(ms1.outlet, mfr1.Feed) annotation(
    Line(points = {{-48, -4}, {-20, -4}}, color = {0, 70, 70}));
  ms1.compMolFrac[1, :] = {0.4, 0.6, 0};
  ms1.P = 101325;
  ms1.T = 350;
  ms1.totMolFlo[1] = 100;
  mfr1.V = 100;
end Test_M;



end CSTR_Test;
