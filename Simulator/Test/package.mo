within Simulator;

package Test
  model msTP
    //we have to first instance components to give to material stream model.
    import data = Simulator.Files.Chemsep_Database;
    //instantiation of chemsep database
    parameter data.Methanol meth;
    //instantiation of methanol
    parameter data.Ethanol eth;
    //instantiation of ethanol
    parameter data.Water wat;
    //instantiation of water
    extends Streams.Material_Stream(NOC = 3, comp = {meth, eth, wat});
    //material stream model is extended and values of parameters NOC and comp are given. These parameters are declared in Material stream model. We are only giving them values here.
    //NOC - number of components, comp -  component array.
    //start values are given for convergence
    extends Simulator.Files.Thermodynamic_Packages.Raoults_Law;
    //Thermodynamic package is extended. We can use other thermodynamics also(not yet added) after little modification and inclusion of residual properties equations.
  equation
//These are the values to be specified by user. In this P, T, mixture mole fraction and mixture molar flow is specified. These variables are declared in Material stream model, only values are given here.
    P = 101325;
    T = 351;
    compMolFrac[1, :] = {0.33, 0.33, 0.34};
    totMolFlo[1] = 100;
  end msTP;

  model msTVF
    // database and components are instantiated, material stream and thermodynamic package extended
    Simulator.Files.Chemsep_Database data;
    parameter data.Methanol meth;
    parameter data.Ethanol eth;
    parameter data.Water wat;
    extends Streams.Material_Stream(NOC = 3, comp = {meth, eth, wat});
    //NOC - number of components, comp -  component array.
    extends Simulator.Files.Thermodynamic_Packages.Raoults_Law;
  equation
//Here vapor phase mole fraction, temperature, mixture component mole fraction and mixture molar flow is given.
    vapPhasMolFrac = 0.036257;
    T = 351;
    compMolFrac[1, :] = {0.33, 0.33, 0.34};
    totMolFlo[1] = 31.346262;
  end msTVF;

  model msPVF
    import data = Simulator.Files.Chemsep_Database;
    parameter data.Methanol meth;
    parameter data.Ethanol eth;
    parameter data.Water wat;
    extends Streams.Material_Stream(NOC = 3, comp = {meth, eth, wat});
    extends Simulator.Files.Thermodynamic_Packages.Raoults_Law;
  equation
    P = 101325;
    vapPhasMolFrac = 0.036257;
    compMolFrac[1, :] = {0.33, 0.33, 0.34};
    totMolFlo[1] = 100;
  end msPVF;

  model msPH
    //we have to first instance components to give to material stream model.
    import data = Simulator.Files.Chemsep_Database;
    //instantiation of chemsep database
    parameter data.Methanol meth;
    //instantiation of methanol
    parameter data.Ethanol eth;
    //instantiation of ethanol
    parameter data.Water wat;
    //instantiation of water
    extends Streams.Material_Stream(NOC = 3, comp = {meth, eth, wat});
    //material stream model is extended and values of parameters NOC and comp are given. These parameters are declred in Material stream model. We are only giving them values here.
    //we need to give proper initialization values for converging, Initialization values are provided for totMolFlo, compMolFrac and T while extending.
    //NOC - number of components, comp -  component array.
    extends Simulator.Files.Thermodynamic_Packages.Raoults_Law;
    //Thermodynamic package is extended. We can use other thermodynamics also(not yet added) after little modification and inclusion of residual properties equations.
  equation
//These are the values to be specified by user. In this P, mixture molar enthalpy, mixture mole fraction and mixture molar flow is specified. These variables are declared in Material stream model, only values are given here.
    P = 101325;
    phasMolEnth[1] = -34452;
    compMolFrac[1, :] = {0.33, 0.33, 0.34};
//1 stands for mixture
    totMolFlo[1] = 31.346262;
//1 stands for mixture
  end msPH;

  model msPS
    //we have to first instance components to give to material stream model.
    import data = Simulator.Files.Chemsep_Database;
    //instantiation of chemsep database
    parameter data.Methanol meth;
    //instantiation of methanol
    parameter data.Ethanol eth;
    //instantiation of ethanol
    parameter data.Water wat;
    //instantiation of water
    extends Streams.Material_Stream(NOC = 3, comp = {meth, eth, wat}, totMolFlo(each start = 100), compMolFrac(each start = 0.33), T(start = sum(comp.Tb) / NOC));
    //material stream model is extended and values of parameters NOC and comp are given. These parameters are declred in Material stream model. We are only giving them values here.
    //we need to give proper initialization values for converging, Initialization values are provided for totMolFlo, compMolFrac and T while extending.
    //NOC - number of components, comp -  component array.
    extends Simulator.Files.Thermodynamic_Packages.Raoults_Law;
    //Thermodynamic package is extended. We can use other thermodynamics also(not yet added) after little modification and inclusion of residual properties equations.
  equation
//These are the values to be specified by user. In this P, mixture molar enthalpy, mixture mole fraction and mixture molar flow is specified. These variables are declared in Material stream model, only values are given here.
    P = 101325;
    phasMolEntr[1] = -84.39;
    compMolFrac[1, :] = {0.33, 0.33, 0.34};
//1 stands for mixture
    totMolFlo[1] = 31.346262;
//1 stands for mixture
  end msPS;

  model msTPbbp "material stream below bubble point"
    //we have to first instance components to give to material stream model.
    import data = Simulator.Files.Chemsep_Database;
    //instantiation of chemsep database
    parameter data.Methanol meth;
    //instantiation of methanol
    parameter data.Ethanol eth;
    //instantiation of ethanol
    parameter data.Water wat;
    //instantiation of water
    extends Streams.Material_Stream(NOC = 3, comp = {meth, eth, wat}, compMolEnth(each start = eth.SH), compMolEntr(each start = eth.AS), compMolFrac(each min = 0.01, each max = 1, each start = 0.33));
    //material stream model is extended and values of parameters NOC and comp are given. These parameters are declared in Material stream model. We are only giving them values here.
    //NOC - number of components, comp -  component array.
    extends Simulator.Files.Thermodynamic_Packages.Raoults_Law;
    //Thermodynamic package is extended. We can use other thermodynamics also(not yet added) after little modification and inclusion of residual properties equations.
  equation
//These are the values to be specified by user. In this P, T, mixture mole fraction and mixture molar flow is specified. These variables are declared in Material stream model, only values are given here.
    P = 202650;
    T = 320;
    compMolFrac[1, :] = {0.33, 0.33, 0.34};
//1 stands for mixture
    totMolFlo[1] = 31.346262;
//1 stands for mixture
  end msTPbbp;

  model msTPUNIQUAC
    import data = Simulator.Files.Chemsep_Database;
    parameter data.Ethanol eth;
    parameter data.Water wat;
    extends Simulator.Streams.Material_Stream(NOC = 2, comp = {eth, wat});
    extends Simulator.Files.Thermodynamic_Packages.UNIQUAC;
  equation
    compMolFrac[1, :] = {0.5, 0.5};
    totMolFlo[1] = 50;
    P = 101325;
    T = 354;
  end msTPUNIQUAC;

  model msTPNRTL
    import data = Simulator.Files.Chemsep_Database;
    parameter data.Onehexene ohex;
    parameter data.Ethanol eth;
    extends Simulator.Streams.Material_Stream(NOC = 2, comp = {ohex, eth}, compMolFrac(each start = 0.33));
    extends Simulator.Files.Thermodynamic_Packages.NRTL;
  equation
    compMolFrac[1, :] = {0.5, 0.5};
    totMolFlo[1] = 100;
    P = 101325;
    T = 330;
  end msTPNRTL;

  model msTPGrayson
    import data = Simulator.Files.Chemsep_Database;
    parameter data.Ethylene eth;
    parameter data.Acetylene acet;
    parameter data.OneOnedichloroethane dich;
    parameter data.Propadiene prop;
    //w=Acentric Factor
    //Sp = Solublity Parameter
    //V = Molar Volume
    //All the above three parameters have to be mentioned as arguments while extending the thermodynamic Package Grayson Streed  as shown below
    extends Simulator.Files.Thermodynamic_Packages.Grayson_Streed(w = {0.0949, 0.1841, 0.244612, 0.3125}, Sp = {0.00297044, 0.00449341, 0.00437069, 0.00419199}, V = {61, 42.1382, 84.7207, 60.4292});
    extends Simulator.Streams.Material_Stream(NOC = 4, comp = {eth, acet, dich, prop});
    //Equations
  equation
    P = 101325;
    T = 210.246;
    compMolFrac[1, :] = {0.4, 0.2, 0.3, 0.1};
    totMolFlo[1] = 50;
  end msTPGrayson;

  package cmpstms
    model ms
      extends Simulator.Streams.Material_Stream;
      extends Simulator.Files.Thermodynamic_Packages.Raoults_Law;
    end ms;

    model main
      //instance of database
      import data = Simulator.Files.Chemsep_Database;
      //instance of components
      parameter data.Benzene benz;
      parameter data.Toluene tol;
      //declaration of NOC and comp
      parameter Integer NOC = 2;
      parameter data.General_Properties comp[NOC] = {benz, tol};
      //instance of composite material stream
      Simulator.Test.cmpstms.ms ms1(NOC = NOC, comp = comp) annotation(
        Placement(visible = true, transformation(origin = {-79, -31}, extent = {{-11, -11}, {11, 11}}, rotation = 0)));
    equation
      ms1.P = 101325;
      ms1.T = 368;
      ms1.totMolFlo[1] = 100;
      ms1.compMolFrac[1, :] = {0.5, 0.5};
    end main;
  end cmpstms;

  package heater1
    model ms
      extends Simulator.Streams.Material_Stream;
      //material stream extended
      extends Simulator.Files.Thermodynamic_Packages.Raoults_Law;
      //thermodynamic package Raoults law is extended
    end ms;

    model heat
      //instance of chemsep database
      import data = Simulator.Files.Chemsep_Database;
      //instance of methanol
      parameter data.Methanol meth;
      //instance of ethanol
      parameter data.Ethanol eth;
      //instance of water
      parameter data.Water wat;
      //instance of heater
      parameter Integer NOC = 3;
      parameter data.General_Properties comp[NOC] = {meth, eth, wat};
      Simulator.Unit_Operations.Heater heater1(pressDrop = 101325, eff = 1, NOC = NOC, comp = comp) annotation(
        Placement(visible = true, transformation(origin = {-36, -4}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
      //instances of composite material stream
      Simulator.Test.heater1.ms inlet(NOC = NOC, comp = comp) annotation(
        Placement(visible = true, transformation(origin = {-80, 4}, extent = {{-12, -12}, {12, 12}}, rotation = 0)));
      Simulator.Test.heater1.ms outlet(NOC = NOC, comp = comp) annotation(
        Placement(visible = true, transformation(origin = {20, 8}, extent = {{-12, -12}, {12, 12}}, rotation = 0)));
      //instance of energy stream
      Simulator.Streams.Energy_Stream energy annotation(
        Placement(visible = true, transformation(origin = {-75, -35}, extent = {{-13, -13}, {13, 13}}, rotation = 0)));
      extends Guess_Models.Initial_Guess;
    equation
      connect(energy.outlet, heater1.energy) annotation(
        Line(points = {{-62, -35}, {-62, -34.5}, {-46, -34.5}, {-46, -14}}));
      connect(inlet.outlet, heater1.inlet) annotation(
        Line(points = {{-68, 4}, {-58, 4}, {-58, -4}, {-46, -4}}));
      connect(heater1.outlet, outlet.inlet) annotation(
        Line(points = {{-26, -4}, {-26, -8}, {8, -8}, {8, 8}}));
    equation
      inlet.compMolFrac[1, :] = {0.33, 0.33, 0.34};
//mixture molar composition
      inlet.P = 202650;
//input pressure
      inlet.T = 320;
//input temperature
      inlet.totMolFlo[1] = 100;
//input molar flow
      heater1.heatAdd = 2000000;
//heat added
    end heat;
  end heater1;

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
      Simulator.Unit_Operations.Heat_Exchanger HX(Calculation_Method = "Outlet_Temparatures", Heat_Loss = 0, Mode = "CounterCurrent", NOC = NOC, comp = comp, deltap_cold = 0, deltap_hot = 0) annotation(
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
      Simulator.Unit_Operations.Cooler cooler1(pressDrop = 0, eff = 1, NOC = 3, comp = {meth, eth, wat}) annotation(
        Placement(visible = true, transformation(origin = {-8, 18}, extent = {{-14, -14}, {14, 14}}, rotation = 0)));
      ms inlet(NOC = 3, comp = {meth, eth, wat}) annotation(
        Placement(visible = true, transformation(origin = {-72, 18}, extent = {{-12, -12}, {12, 12}}, rotation = 0)));
      Simulator.Test.cooler1.ms outlet(NOC = 3, comp = {meth, eth, wat}) annotation(
        Placement(visible = true, transformation(origin = {60, 12}, extent = {{-12, -12}, {12, 12}}, rotation = 0)));
      Simulator.Streams.Energy_Stream energy annotation(
        Placement(visible = true, transformation(origin = {47, -27}, extent = {{-13, -13}, {13, 13}}, rotation = 0)));
    equation
      connect(cooler1.energy, energy.inlet) annotation(
        Line(points = {{6, 4}, {6, -27}, {34, -27}}, color = {255, 0, 0}));
      connect(cooler1.outlet, outlet.inlet) annotation(
        Line(points = {{6, 18}, {26, 18}, {26, 12}, {48, 12}}));
      connect(inlet.outlet, cooler1.inlet) annotation(
        Line(points = {{-60, 18}, {-22, 18}}));
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

  package valve1
    model ms
      //This model will be instantiated in maintest model as outlet stream of valve. Dont run this model. Run maintest model for valve test
      extends Simulator.Streams.Material_Stream;
      //material stream extended
      extends Simulator.Files.Thermodynamic_Packages.Raoults_Law;
      //thermodynamic package Raoults law is extended
    end ms;

    model valve
      import data = Simulator.Files.Chemsep_Database;
      //instantiation of chemsep database
      parameter data.Methanol meth;
      //instantiation of methanol
      parameter data.Ethanol eth;
      //instantiation of ethanol
      parameter data.Water wat;
      //instantiation of water
      parameter Integer NOC = 3;
      parameter data.General_Properties comp[NOC] = {meth, eth, wat};
      Simulator.Unit_Operations.Valve valve1(NOC = NOC, comp = comp) annotation(
        Placement(visible = true, transformation(origin = {0, 4}, extent = {{-14, -14}, {14, 14}}, rotation = 0)));
      ms inlet(NOC = NOC, comp = comp) annotation(
        Placement(visible = true, transformation(origin = {-74, 4}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
      Simulator.Test.valve1.ms outlet(NOC = NOC, comp = comp) annotation(
        Placement(visible = true, transformation(origin = {71, 3}, extent = {{-11, -11}, {11, 11}}, rotation = 0)));
    equation
      connect(valve1.outlet, outlet.inlet) annotation(
        Line(points = {{14, 4}, {35, 4}, {35, 3}, {60, 3}}, color = {0, 70, 70}));
      connect(inlet.outlet, valve1.inlet) annotation(
        Line(points = {{-64, 4}, {-14, 4}}, color = {0, 70, 70}));
      inlet.compMolFrac[1, :] = {0.33, 0.33, 0.34};
//mixture molar composition
      inlet.P = 202650;
//input pressure
      valve1.pressDrop = 101325;
//Pressure Drop
      inlet.T = 372;
//input temperature
      inlet.totMolFlo[1] = 100;
//input molar flow
    end valve;
  end valve1;

  package mix1
    model ms
      //This model will be instantiated in maintest model as material streams
      extends Simulator.Streams.Material_Stream;
      //material stream extended
      extends Simulator.Files.Thermodynamic_Packages.Raoults_Law;
      //thermodynamic package Raoults law is extended
    end ms;

    model mix
      import data = Simulator.Files.Chemsep_Database;
      parameter data.Ethanol eth;
      parameter data.Methanol meth;
      parameter data.Water wat;
      parameter Integer NOC = 3;
      parameter data.General_Properties comp[NOC] = {meth, eth, wat};
      ms ms1(NOC = NOC, comp = comp) annotation(
        Placement(visible = true, transformation(origin = {-84, 88}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
      ms ms2(NOC = NOC, comp = comp) annotation(
        Placement(visible = true, transformation(origin = {-84, 58}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
      ms ms3(NOC = NOC, comp = comp) annotation(
        Placement(visible = true, transformation(origin = {-86, 24}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
      ms ms4(NOC = NOC, comp = comp) annotation(
        Placement(visible = true, transformation(origin = {-84, -16}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
      ms ms5(NOC = NOC, comp = comp) annotation(
        Placement(visible = true, transformation(origin = {-84, -52}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
      ms ms6(NOC = NOC, comp = comp) annotation(
        Placement(visible = true, transformation(origin = {-82, -86}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
      Simulator.Unit_Operations.Mixer mixer1(NOC = NOC, NI = 6, comp = comp, outPress = "Inlet_Average") annotation(
        Placement(visible = true, transformation(origin = {-8, 2}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
      ms out1(NOC = NOC, comp = comp) annotation(
        Placement(visible = true, transformation(origin = {62, 2}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    equation
      connect(mixer1.outlet, out1.inlet) annotation(
        Line(points = {{12, 2}, {52, 2}}));
      connect(ms6.outlet, mixer1.inlet[6]) annotation(
        Line(points = {{-72, -86}, {-28, -86}, {-28, 2}}));
      connect(ms5.outlet, mixer1.inlet[5]) annotation(
        Line(points = {{-74, -52}, {-44, -52}, {-44, 2}, {-28, 2}}));
      connect(ms4.outlet, mixer1.inlet[4]) annotation(
        Line(points = {{-74, -16}, {-50, -16}, {-50, 2}, {-28, 2}}));
      connect(ms3.outlet, mixer1.inlet[3]) annotation(
        Line(points = {{-76, 24}, {-50, 24}, {-50, 2}, {-28, 2}}));
      connect(ms2.outlet, mixer1.inlet[2]) annotation(
        Line(points = {{-74, 58}, {-44, 58}, {-44, 2}, {-28, 2}}));
      connect(ms1.outlet, mixer1.inlet[1]) annotation(
        Line(points = {{-74, 88}, {-28, 88}, {-28, 2}}));
    equation
      ms1.P = 101325;
      ms2.P = 202650;
      ms3.P = 126523;
      ms4.P = 215365;
      ms5.P = 152365;
      ms6.P = 152568;
      ms1.T = 353;
      ms2.T = 353;
      ms3.T = 353;
      ms4.T = 353;
      ms5.T = 353;
      ms6.T = 353;
      ms1.totMolFlo[1] = 100;
      ms2.totMolFlo[1] = 100;
      ms3.totMolFlo[1] = 300;
      ms4.totMolFlo[1] = 500;
      ms5.totMolFlo[1] = 400;
      ms6.totMolFlo[1] = 200;
      ms1.compMolFrac[1, :] = {0.25, 0.25, 0.5};
      ms2.compMolFrac[1, :] = {0, 0, 1};
      ms3.compMolFrac[1, :] = {0.3, 0.3, 0.4};
      ms4.compMolFrac[1, :] = {0.25, 0.25, 0.5};
      ms5.compMolFrac[1, :] = {0.2, 0.4, 0.4};
      ms6.compMolFrac[1, :] = {0, 1, 0};
    end mix;
  end mix1;

  package comp_sep1
    model ms
      extends Simulator.Streams.Material_Stream(NOC = 2, comp = {benz, tol});
      extends Simulator.Files.Thermodynamic_Packages.Raoults_Law;
    end ms;

    model main
      import data = Simulator.Files.Chemsep_Database;
      parameter data.Benzene benz;
      parameter data.Toluene tol;
      ms Inlet(NOC = 2, comp = {benz, tol}) annotation(
        Placement(visible = true, transformation(origin = {-82, -2}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
      ms Outlet1(NOC = 2, comp = {benz, tol}) annotation(
        Placement(visible = true, transformation(origin = {64, 18}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
      Simulator.Test.comp_sep1.ms Outlet2(NOC = 2, comp = {benz, tol}) annotation(
        Placement(visible = true, transformation(origin = {66, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
      Simulator.Streams.Energy_Stream Energy annotation(
        Placement(visible = true, transformation(origin = {-40, -50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
      Simulator.Unit_Operations.Compound_Separator compound_Separator1(NOC = 2, comp = {benz, tol}, sepFact = {"Molar_Flow", "Mass_Flow"}, sepStrm = 1) annotation(
        Placement(visible = true, transformation(origin = {-20, 8}, extent = {{-10, -20}, {10, 20}}, rotation = 0)));
    equation
      connect(Inlet.outlet, compound_Separator1.inlet) annotation(
        Line(points = {{-72, -2}, {-43, -2}, {-43, 8}, {-32, 8}}));
      connect(compound_Separator1.outlet1, Outlet1.inlet) annotation(
        Line(points = {{-8, 14}, {22, 14}, {22, 18}, {54, 18}}));
      connect(compound_Separator1.outlet2, Outlet2.inlet) annotation(
        Line(points = {{-8, 3}, {26, 3}, {26, -20}, {56, -20}}));
      connect(Energy.outlet, compound_Separator1.energy) annotation(
        Line(points = {{-30, -50}, {-20, -50}, {-20, -5}}, color = {255, 0, 0}));
      Inlet.P = 101325;
      Inlet.T = 298.15;
      Inlet.compMolFrac[1, :] = {0.5, 0.5};
      Inlet.totMolFlo[1] = 100;
      compound_Separator1.sepFactVal = {20, 1500};
    end main;
  end comp_sep1;

  package shortcut1
    model ms
      extends Simulator.Streams.Material_Stream;
      extends Simulator.Files.Thermodynamic_Packages.Raoults_Law;
    end ms;

    model Shortcut
      extends Simulator.Unit_Operations.Shortcut_Column;
      extends Simulator.Files.Thermodynamic_Packages.Raoults_Law;
    end Shortcut;

    model main
      //use non linear solver homotopy for solving
      import data = Simulator.Files.Chemsep_Database;
      parameter data.Benzene benz;
      parameter data.Toluene tol;
      parameter Integer NOC = 2;
      parameter Simulator.Files.Chemsep_Database.General_Properties comp[NOC] = {benz, tol};
      Simulator.Test.shortcut1.ms feed(NOC = NOC, comp = comp, compMolFrac(start = {{0.5, 0.5}, {0.34, 0.65}, {0.56, 0.44}})) annotation(
        Placement(visible = true, transformation(origin = {-79, 15}, extent = {{-13, -13}, {13, 13}}, rotation = 0)));
      Simulator.Test.shortcut1.ms bottoms(NOC = NOC, comp = comp, T(start = 383.08), compMolFrac(start = {{0.01, 0.99}, {0.01, 0.99}, {0, 0}})) annotation(
        Placement(visible = true, transformation(origin = {64, -18}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
      Simulator.Test.shortcut1.ms distillate(NOC = NOC, comp = comp, T(start = 353.83), compMolFrac(start = {{0.99, 0.01}, {0.99, 0.01}, {0, 0}})) annotation(
        Placement(visible = true, transformation(origin = {66, 56}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
      Simulator.Streams.Energy_Stream Condensor_Duty annotation(
        Placement(visible = true, transformation(origin = {54, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
      Simulator.Streams.Energy_Stream Reboiler_Duty annotation(
        Placement(visible = true, transformation(origin = {62, -60}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
      Shortcut shortcut1(NOC = NOC, comp = comp, HKey = 2, LKey = 1) annotation(
        Placement(visible = true, transformation(origin = {-20, 16}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    equation
      connect(feed.outlet, shortcut1.feed) annotation(
        Line(points = {{-66, 15}, {-46, 15}, {-46, 16}}));
      connect(shortcut1.condenser_duty, Condensor_Duty.inlet) annotation(
        Line(points = {{10, 78}, {24, 78}, {24, 80}, {44, 80}}, color = {255, 0, 0}));
      connect(shortcut1.reboiler_duty, Reboiler_Duty.outlet) annotation(
        Line(points = {{6, -44}, {24, -44}, {24, -60}, {52, -60}, {52, -60}}, color = {255, 0, 0}));
      connect(shortcut1.distillate, distillate.inlet) annotation(
        Line(points = {{6, 44}, {30, 44}, {30, 56}, {56, 56}, {56, 56}}));
      connect(shortcut1.bottoms, bottoms.inlet) annotation(
        Line(points = {{6, -12}, {54, -12}, {54, -18}, {54, -18}}));
      feed.P = 101325;
      feed.T = 370;
      feed.compMolFrac[1, :] = {0.5, 0.5};
      feed.totMolFlo[1] = 100;
      shortcut1.rebP = 101325;
      shortcut1.condP = 101325;
      shortcut1.mixMolFrac[2, shortcut1.LKey] = 0.01;
      shortcut1.mixMolFrac[3, shortcut1.HKey] = 0.01;
      shortcut1.actR = 2;
    end main;
  end shortcut1;

  package flash
    model ms
      extends Simulator.Streams.Material_Stream;
      extends Simulator.Files.Thermodynamic_Packages.Raoults_Law;
    end ms;

    model fls
      extends Simulator.Unit_Operations.Flash;
      extends Simulator.Files.Thermodynamic_Packages.Raoults_Law;
    end fls;

    model test
      import data = Simulator.Files.Chemsep_Database;
      parameter data.Benzene benz;
      parameter data.Toluene tol;
      parameter Integer NOC = 2;
      parameter data.General_Properties comp[NOC] = {benz, tol};
      ms inlet(NOC = NOC, comp = comp) annotation(
        Placement(visible = true, transformation(origin = {-70, 2}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
      Simulator.Test.flash.fls fls1(NOC = NOC, comp = comp) annotation(
        Placement(visible = true, transformation(origin = {-14, 4}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
      ms outlet1(NOC = NOC, comp = comp) annotation(
        Placement(visible = true, transformation(origin = {66, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
      ms outlet2(NOC = NOC, comp = comp) annotation(
        Placement(visible = true, transformation(origin = {58, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    equation
      connect(outlet2.inlet, fls1.vapor) annotation(
        Line(points = {{48, 40}, {28, 40}, {28, 10}, {-4, 10}, {-4, 11}}));
      connect(fls1.liquid, outlet1.inlet) annotation(
        Line(points = {{-4, -3}, {32, -3}, {32, -20}, {56, -20}}));
      connect(inlet.outlet, fls1.feed) annotation(
        Line(points = {{-60, 2}, {-24, 2}, {-24, 4}}));
      inlet.P = 101325;
      inlet.T = 368;
      inlet.compMolFrac[1, :] = {0.5, 0.5};
      inlet.totMolFlo[1] = 100;
    end test;
  end flash;

  package split
    model ms
      extends Simulator.Streams.Material_Stream;
      extends Simulator.Files.Thermodynamic_Packages.Raoults_Law;
    end ms;

    model main
      import data = Simulator.Files.Chemsep_Database;
      parameter data.Benzene benz;
      parameter data.Toluene tol;
      parameter Integer NOC = 2;
      parameter data.General_Properties comp[NOC] = {benz, tol};
      ms inlet(NOC = NOC, comp = comp) annotation(
        Placement(visible = true, transformation(origin = {-80, 10}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
      ms outlet1(NOC = NOC, comp = comp) annotation(
        Placement(visible = true, transformation(origin = {38, 56}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
      ms outlet2(NOC = NOC, comp = comp) annotation(
        Placement(visible = true, transformation(origin = {38, -58}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
      Simulator.Unit_Operations.Splitter split(NOC = NOC, comp = comp, NO = 2, calcType = "Molar_Flow") annotation(
        Placement(visible = true, transformation(origin = {-30, 10}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    equation
      connect(inlet.outlet, split.inlet) annotation(
        Line(points = {{-70, 10}, {-40, 10}}));
      connect(outlet1.inlet, split.outlet[1]) annotation(
        Line(points = {{28, 56}, {12, 56}, {12, 10}, {-20, 10}}));
      connect(outlet2.inlet, split.outlet[2]) annotation(
        Line(points = {{28, -58}, {16, -58}, {16, 10}, {-20, 10}}));
//  connect(split.outlet[1], outlet1.inlet);
//  connect(split.outlet[2], outlet2.inlet);
      inlet.P = 101325;
      inlet.T = 300;
      inlet.compMolFrac[1, :] = {0.5, 0.5};
      inlet.totMolFlo[1] = 100;
      split.specVal = {20, 80};
    end main;
  end split;

  package pump
    model ms
      extends Simulator.Streams.Material_Stream;
      extends Simulator.Files.Thermodynamic_Packages.Raoults_Law;
    end ms;

    model main
      import data = Simulator.Files.Chemsep_Database;
      parameter data.Benzene benz;
      parameter data.Toluene tol;
      Simulator.Test.pump.ms inlet(NOC = 2, comp = {benz, tol}) annotation(
        Placement(visible = true, transformation(origin = {-70, -8}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
      Simulator.Unit_Operations.Centrifugal_Pump pump(comp = {benz, tol}, NOC = 2, eff = 0.75) annotation(
        Placement(visible = true, transformation(origin = {-2, -2}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
      Simulator.Test.pump.ms outlet(NOC = 2, comp = {benz, tol}) annotation(
        Placement(visible = true, transformation(origin = {68, 16}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
      Streams.Energy_Stream energy annotation(
        Placement(visible = true, transformation(origin = {-38, -44}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    equation
      connect(inlet.outlet, pump.inlet) annotation(
        Line(points = {{-60, -8}, {-35, -8}, {-35, 0}, {-12, 0}}));
      connect(pump.outlet, outlet.inlet) annotation(
        Line(points = {{8, 8}, {33, 8}, {33, 16}, {58, 16}}));
      connect(energy.outlet, pump.energy) annotation(
        Line(points = {{-28, -44}, {-2, -44}, {-2, -12}}));
      inlet.totMolFlo[1] = 100;
      inlet.compMolFrac[1, :] = {0.5, 0.5};
      inlet.P = 101325;
      inlet.T = 300;
      pump.pressInc = 101325;
    end main;
  end pump;

  package adia_comp1
    model ms
      //This model will be instantiated in adia_comp model as outlet stream of heater. Dont run this model. Run adia_comp model for test
      extends Simulator.Streams.Material_Stream;
      extends Simulator.Files.Thermodynamic_Packages.Raoults_Law;
    end ms;

    model compres
      extends Unit_Operations.Adiabatic_Compressor;
      extends Files.Thermodynamic_Packages.Raoults_Law;
    end compres;

    model main
      import data = Simulator.Files.Chemsep_Database;
      //instantiation of chemsep database
      parameter data.Benzene ben;
      //instantiation of methanol
      parameter data.Toluene tol;
      //instantiation of ethanol
      parameter Integer NOC = 2;
      parameter data.General_Properties comp[NOC] = {ben, tol};
      Simulator.Test.adia_comp1.compres adiabatic_Compressor1(NOC = NOC, comp = comp, eff = 0.75) annotation(
        Placement(visible = true, transformation(origin = {-17, 17}, extent = {{-15, -15}, {15, 15}}, rotation = 0)));
      Simulator.Test.adia_comp1.ms inlet(NOC = NOC, comp = comp) annotation(
        Placement(visible = true, transformation(origin = {-78, 8}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
      ms outlet(NOC = NOC, comp = comp, T(start = 374)) annotation(
        Placement(visible = true, transformation(origin = {58, 6}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
      Simulator.Streams.Energy_Stream power annotation(
        Placement(visible = true, transformation(origin = {-50, -56}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    equation
      connect(inlet.outlet, adiabatic_Compressor1.inlet) annotation(
        Line(points = {{-68, 8}, {-50, 8}, {-50, 17}, {-32, 17}}));
      connect(adiabatic_Compressor1.outlet, outlet.inlet) annotation(
        Line(points = {{-2, 17}, {31, 17}, {31, 6}, {48, 6}}));
      connect(power.outlet, adiabatic_Compressor1.energy) annotation(
        Line(points = {{-40, -56}, {-17, -56}, {-17, 7}}));
      inlet.compMolFrac[1, :] = {0.5, 0.5};
//mixture molar composition
      inlet.P = 202650;
//input pressure
      inlet.T = 372;
//input temperature
      inlet.totMolFlo[1] = 100;
//input molar flow
      adiabatic_Compressor1.pressInc = 10000;
//pressure increase
    end main;
  end adia_comp1;

  package adia_exp1
    model ms
      extends Simulator.Streams.Material_Stream;
      extends Simulator.Files.Thermodynamic_Packages.Raoults_Law;
    end ms;

    model exp
      extends Simulator.Unit_Operations.Adiabatic_Expander;
      extends Simulator.Files.Thermodynamic_Packages.Raoults_Law;
    end exp;

    model main
      import data = Simulator.Files.Chemsep_Database;
      //instantiation of chemsep database
      parameter data.Benzene ben;
      //instantiation of methanol
      parameter data.Toluene tol;
      //instantiation of ethanol
      parameter Integer NOC = 2;
      parameter data.General_Properties comp[NOC] = {ben, tol};
      Simulator.Test.adia_exp1.exp exp1(NOC = NOC, comp = comp, eff = 0.75) annotation(
        Placement(visible = true, transformation(origin = {-9, 7}, extent = {{-23, -23}, {23, 23}}, rotation = 0)));
      Simulator.Test.adia_comp1.ms inlet(NOC = NOC, comp = comp) annotation(
        Placement(visible = true, transformation(origin = {-78, 8}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
      ms outlet(NOC = NOC, comp = comp, T(start = 374)) annotation(
        Placement(visible = true, transformation(origin = {58, 6}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
      Simulator.Streams.Energy_Stream power annotation(
        Placement(visible = true, transformation(origin = {-50, -56}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    equation
      connect(power.outlet, exp1.energy) annotation(
        Line(points = {{-40, -56}, {-10, -56}, {-10, -16}, {-8, -16}}));
      connect(exp1.outlet, outlet.inlet) annotation(
        Line(points = {{14, 6}, {48, 6}, {48, 6}, {48, 6}}));
      connect(inlet.outlet, exp1.inlet) annotation(
        Line(points = {{-68, 8}, {-32, 8}}));
      inlet.compMolFrac[1, :] = {0.5, 0.5};
//mixture molar composition
      inlet.P = 131325;
//input pressure
      inlet.T = 372;
//input temperature
      inlet.totMolFlo[1] = 100;
//input molar flow
      exp1.pressDrop = 10000;
//pressure drop
    end main;
  end adia_exp1;

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
      Condensor condensor(NOC = NOC, comp = comp, condType = condType, boolFeed = boolFeed[1], T(start = 300));
      Reboiler reboiler(NOC = NOC, comp = comp, boolFeed = boolFeed[noOfStages]);
      Tray tray[noOfStages - 2](each NOC = NOC, each comp = comp, boolFeed = boolFeed[2:noOfStages - 1], each liqMolFlo(each start = 150), each vapMolFlo(each start = 150));
    end DistColumn;

    model ms
      extends Simulator.Streams.Material_Stream;
      extends Simulator.Files.Thermodynamic_Packages.Raoults_Law;
    end ms;

    model Test
      parameter Integer NOC = 2;
      import data = Simulator.Files.Chemsep_Database;
      parameter data.Benzene benz;
      parameter data.Toluene tol;
      parameter Simulator.Files.Chemsep_Database.General_Properties comp[NOC] = {benz, tol};
      Simulator.Test.rigDist.DistColumn distCol(NOC = NOC, comp = comp, noOfStages = 4, noOfFeeds = 1, feedStages = {3}) annotation(
        Placement(visible = true, transformation(origin = {-22, 8}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
      ms feed(NOC = NOC, comp = comp) annotation(
        Placement(visible = true, transformation(origin = {-76, 2}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
      ms distillate(NOC = NOC, comp = comp) annotation(
        Placement(visible = true, transformation(origin = {64, 22}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
      ms bottoms(NOC = NOC, comp = comp) annotation(
        Placement(visible = true, transformation(origin = {68, -16}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
      Simulator.Streams.Energy_Stream cond_duty annotation(
        Placement(visible = true, transformation(origin = {38, 62}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
      Simulator.Streams.Energy_Stream reb_duty annotation(
        Placement(visible = true, transformation(origin = {48, -52}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    equation
      connect(distCol.condensor_duty, cond_duty.inlet) annotation(
        Line(points = {{3, 68}, {14.5, 68}, {14.5, 62}, {28, 62}}));
      connect(distCol.reboiler_duty, reb_duty.inlet) annotation(
        Line(points = {{3, -52}, {38, -52}}));
      connect(distCol.bottoms, bottoms.inlet) annotation(
        Line(points = {{3, -22}, {29.5, -22}, {29.5, -16}, {58, -16}}));
      connect(distCol.distillate, distillate.inlet) annotation(
        Line(points = {{3, 38}, {26.5, 38}, {26.5, 22}, {54, 22}}));
      connect(feed.outlet, distCol.feed[1]) annotation(
        Line(points = {{-66, 2}, {-57.5, 2}, {-57.5, 8}, {-47, 8}}));
      feed.P = 101325;
      feed.T = 298.15;
      feed.totMolFlo[1] = 100;
      feed.compMolFrac[1, :] = {0.5, 0.5};
      distCol.condensor.P = 101325;
      distCol.reboiler.P = 101325;
      distCol.refluxRatio = 2;
      bottoms.totMolFlo[1] = 50;
    end Test;

    model Test2
      parameter Integer NOC = 2;
      import data = Simulator.Files.Chemsep_Database;
      parameter data.Benzene benz;
      parameter data.Toluene tol;
      parameter Simulator.Files.Chemsep_Database.General_Properties comp[NOC] = {benz, tol};
      DistColumn distCol(NOC = NOC, comp = comp, noOfStages = 12, noOfFeeds = 1, feedStages = {7}) annotation(
        Placement(visible = true, transformation(origin = {-3, 3}, extent = {{-25, -25}, {25, 25}}, rotation = 0)));
      ms feed(NOC = NOC, comp = comp) annotation(
        Placement(visible = true, transformation(origin = {-76, 2}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
      ms distillate(NOC = NOC, comp = comp) annotation(
        Placement(visible = true, transformation(origin = {64, 22}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
      ms bottoms(NOC = NOC, comp = comp) annotation(
        Placement(visible = true, transformation(origin = {68, -16}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
      Simulator.Streams.Energy_Stream cond_duty annotation(
        Placement(visible = true, transformation(origin = {38, 62}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
      Simulator.Streams.Energy_Stream reb_duty annotation(
        Placement(visible = true, transformation(origin = {48, -52}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    equation
      connect(distCol.condensor_duty, cond_duty.inlet) annotation(
        Line(points = {{12, 28}, {12, 28}, {12, 62}, {28, 62}, {28, 62}}));
      connect(distCol.reboiler_duty, reb_duty.inlet) annotation(
        Line(points = {{16, -22}, {16, -22}, {16, -52}, {38, -52}, {38, -52}}));
      connect(distCol.bottoms, bottoms.inlet) annotation(
        Line(points = {{22, -14}, {56, -14}, {56, -16}, {58, -16}}));
      connect(distCol.distillate, distillate.inlet) annotation(
        Line(points = {{22, 22}, {54, 22}, {54, 22}, {54, 22}}));
      connect(feed.outlet, distCol.feed[1]) annotation(
        Line(points = {{-66, 2}, {-30, 2}, {-30, 2}, {-28, 2}}));
      feed.P = 101325;
      feed.T = 298.15;
      feed.totMolFlo[1] = 100;
      feed.compMolFrac[1, :] = {0.3, 0.7};
      distCol.condensor.P = 101325;
      distCol.reboiler.P = 101325;
      distCol.refluxRatio = 2;
      bottoms.totMolFlo[1] = 50;
    end Test2;

    model Test3
      parameter Integer NOC = 2;
      import data = Simulator.Files.Chemsep_Database;
      parameter data.Benzene benz;
      parameter data.Toluene tol;
      parameter Simulator.Files.Chemsep_Database.General_Properties comp[NOC] = {benz, tol};
      DistColumn distCol(NOC = NOC, comp = comp, noOfFeeds = 1, noOfStages = 22, feedStages = {10}) annotation(
        Placement(visible = true, transformation(origin = {-3, 3}, extent = {{-25, -25}, {25, 25}}, rotation = 0)));
      ms feed(NOC = NOC, comp = comp) annotation(
        Placement(visible = true, transformation(origin = {-76, 2}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
      ms distillate(NOC = NOC, comp = comp) annotation(
        Placement(visible = true, transformation(origin = {64, 22}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
      ms bottoms(NOC = NOC, comp = comp) annotation(
        Placement(visible = true, transformation(origin = {68, -16}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
      Simulator.Streams.Energy_Stream cond_duty annotation(
        Placement(visible = true, transformation(origin = {38, 62}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
      Simulator.Streams.Energy_Stream reb_duty annotation(
        Placement(visible = true, transformation(origin = {48, -52}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    equation
      connect(distCol.condensor_duty, cond_duty.inlet) annotation(
        Line(points = {{12, 28}, {12, 28}, {12, 62}, {28, 62}, {28, 62}}));
      connect(distCol.reboiler_duty, reb_duty.inlet) annotation(
        Line(points = {{16, -22}, {16, -22}, {16, -52}, {38, -52}, {38, -52}}));
      connect(distCol.bottoms, bottoms.inlet) annotation(
        Line(points = {{22, -14}, {56, -14}, {56, -16}, {58, -16}}));
      connect(distCol.distillate, distillate.inlet) annotation(
        Line(points = {{22, 22}, {54, 22}, {54, 22}, {54, 22}}));
      connect(feed.outlet, distCol.feed[1]) annotation(
        Line(points = {{-66, 2}, {-30, 2}, {-30, 2}, {-28, 2}}));
      feed.P = 101325;
      feed.T = 298.15;
      feed.totMolFlo[1] = 100;
      feed.compMolFrac[1, :] = {0.3, 0.7};
      distCol.condensor.P = 101325;
      distCol.reboiler.P = 101325;
      distCol.refluxRatio = 1.5;
      bottoms.totMolFlo[1] = 70;
    end Test3;

    model Test4
      parameter Integer NOC = 2;
      import data = Simulator.Files.Chemsep_Database;
      parameter data.Benzene benz;
      parameter data.Toluene tol;
      parameter Simulator.Files.Chemsep_Database.General_Properties comp[NOC] = {benz, tol};
      DistColumn distCol(NOC = NOC, comp = comp, noOfStages = 22, noOfFeeds = 1, feedStages = {10}, condensor.condType = "Partial", each tray.liqMolFlo(each start = 100), each tray.vapMolFlo(each start = 100)) annotation(
        Placement(visible = true, transformation(origin = {-3, 3}, extent = {{-25, -25}, {25, 25}}, rotation = 0)));
      ms feed(NOC = NOC, comp = comp) annotation(
        Placement(visible = true, transformation(origin = {-76, 2}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
      ms distillate(NOC = NOC, comp = comp) annotation(
        Placement(visible = true, transformation(origin = {64, 22}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
      ms bottoms(NOC = NOC, comp = comp) annotation(
        Placement(visible = true, transformation(origin = {68, -16}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
      Simulator.Streams.Energy_Stream cond_duty annotation(
        Placement(visible = true, transformation(origin = {38, 62}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
      Simulator.Streams.Energy_Stream reb_duty annotation(
        Placement(visible = true, transformation(origin = {48, -52}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    equation
      connect(distCol.condensor_duty, cond_duty.inlet) annotation(
        Line(points = {{12, 28}, {12, 28}, {12, 62}, {28, 62}, {28, 62}}));
      connect(distCol.reboiler_duty, reb_duty.inlet) annotation(
        Line(points = {{16, -22}, {16, -22}, {16, -52}, {38, -52}, {38, -52}}));
      connect(distCol.bottoms, bottoms.inlet) annotation(
        Line(points = {{22, -14}, {56, -14}, {56, -16}, {58, -16}}));
      connect(distCol.distillate, distillate.inlet) annotation(
        Line(points = {{22, 22}, {54, 22}, {54, 22}, {54, 22}}));
      connect(feed.outlet, distCol.feed[1]) annotation(
        Line(points = {{-66, 2}, {-30, 2}, {-30, 2}, {-28, 2}}));
      feed.P = 101325;
      feed.T = 298.15;
      feed.totMolFlo[1] = 96.8;
      feed.compMolFrac[1, :] = {0.3, 0.7};
      distCol.condensor.P = 151325;
      distCol.reboiler.P = 101325;
      distCol.refluxRatio = 1.5;
      bottoms.totMolFlo[1] = 70;
    end Test4;

    model multiFeedTest
      parameter Integer NOC = 2;
      import data = Simulator.Files.Chemsep_Database;
      parameter data.Benzene benz;
      parameter data.Toluene tol;
      parameter Simulator.Files.Chemsep_Database.General_Properties comp[NOC] = {benz, tol};
      DistColumn distCol(NOC = NOC, comp = comp, noOfStages = 5, noOfFeeds = 2, feedStages = {3, 4}) annotation(
        Placement(visible = true, transformation(origin = {-3, 3}, extent = {{-25, -25}, {25, 25}}, rotation = 0)));
      ms feed(NOC = NOC, comp = comp) annotation(
        Placement(visible = true, transformation(origin = {-76, 2}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
      ms distillate(NOC = NOC, comp = comp) annotation(
        Placement(visible = true, transformation(origin = {64, 22}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
      ms bottoms(NOC = NOC, comp = comp) annotation(
        Placement(visible = true, transformation(origin = {68, -16}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
      Simulator.Streams.Energy_Stream cond_duty annotation(
        Placement(visible = true, transformation(origin = {38, 62}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
      Simulator.Streams.Energy_Stream reb_duty annotation(
        Placement(visible = true, transformation(origin = {48, -52}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
      ms ms1(NOC = NOC, comp = comp) annotation(
        Placement(visible = true, transformation(origin = {-80, 50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    equation
      connect(ms1.outlet, distCol.feed[2]) annotation(
        Line(points = {{-70, 50}, {-26, 50}, {-26, 2}, {-28, 2}}));
      connect(distCol.condensor_duty, cond_duty.inlet) annotation(
        Line(points = {{12, 28}, {12, 28}, {12, 62}, {28, 62}, {28, 62}}));
      connect(distCol.reboiler_duty, reb_duty.inlet) annotation(
        Line(points = {{16, -22}, {16, -22}, {16, -52}, {38, -52}, {38, -52}}));
      connect(distCol.bottoms, bottoms.inlet) annotation(
        Line(points = {{22, -14}, {56, -14}, {56, -16}, {58, -16}}));
      connect(distCol.distillate, distillate.inlet) annotation(
        Line(points = {{22, 22}, {54, 22}, {54, 22}, {54, 22}}));
      connect(feed.outlet, distCol.feed[1]) annotation(
        Line(points = {{-66, 2}, {-30, 2}, {-30, 2}, {-28, 2}}));
      feed.P = 101325;
      feed.T = 298.15;
      feed.totMolFlo[1] = 100;
      feed.compMolFrac[1, :] = {0.5, 0.5};
      distCol.condensor.P = 101325;
      distCol.reboiler.P = 101325;
      distCol.refluxRatio = 2;
      bottoms.totMolFlo[1] = 50;
      ms1.P = 101325;
      ms1.T = 298.15;
      ms1.totMolFlo[1] = 100;
      ms1.compMolFrac[1, :] = {0.5, 0.5};
    end multiFeedTest;
  end rigDist;

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
        Placement(visible = true, transformation(origin = {-7, 3}, extent = {{-33, -33}, {33, 33}}, rotation = 0)));
      MS Inlet(NOC = NOC, comp = comp) annotation(
        Placement(visible = true, transformation(origin = {-66, 8}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
      MS Outlet(NOC = NOC, comp = comp) annotation(
        Placement(visible = true, transformation(origin = {86, 10}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    equation
      connect(Outlet.inlet, PFR.outlet) annotation(
        Line(points = {{76, 10}, {26, 10}, {26, 3}}));
      connect(PFR.inlet, Inlet.outlet) annotation(
        Line(points = {{-40, 3}, {-48, 3}, {-48, 8}, {-56, 8}}));
      connect(Energy.inlet, PFR.en_Conn) annotation(
        Line(points = {{-8, -36}, {-7, -36}, {-7, -20}}));
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

  package rigAbs
    model ms
      extends Simulator.Streams.Material_Stream;
      extends Simulator.Files.Thermodynamic_Packages.Raoults_Law;
    end ms;

    model Tray
      extends Simulator.Unit_Operations.Absorption_Column.AbsTray;
      extends Simulator.Files.Thermodynamic_Packages.Raoults_Law;
    end Tray;

    model AbsColumn
      extends Simulator.Unit_Operations.Absorption_Column.AbsCol;
      Tray tray[noOfStages](each NOC = NOC, each comp = comp, each liqMolFlo(each start = 30), each vapMolFlo(each start = 30), each T(start = 300));
    end AbsColumn;

    model Test
      import data = Simulator.Files.Chemsep_Database;
      parameter Integer NOC = 3;
      parameter data.Acetone acet;
      parameter data.Air air;
      parameter data.Water wat;
      parameter data.General_Properties comp[NOC] = {acet, air, wat};
      Simulator.Test.rigAbs.ms water(NOC = NOC, comp = comp) annotation(
        Placement(visible = true, transformation(origin = {-90, 66}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
      Simulator.Test.rigAbs.ms air_acetone(NOC = NOC, comp = comp) annotation(
        Placement(visible = true, transformation(origin = {-88, -84}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
      Simulator.Test.rigAbs.AbsColumn abs(NOC = NOC, comp = comp, noOfStages = 10) annotation(
        Placement(visible = true, transformation(origin = {-20, -6}, extent = {{-16, -16}, {16, 16}}, rotation = 0)));
      Simulator.Test.rigAbs.ms top(NOC = NOC, comp = comp) annotation(
        Placement(visible = true, transformation(origin = {62, 62}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
      Simulator.Test.rigAbs.ms bottom(NOC = NOC, comp = comp) annotation(
        Placement(visible = true, transformation(origin = {70, -86}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    equation
      connect(air_acetone.outlet, abs.bottom_feed) annotation(
        Line(points = {{-78, -84}, {-69, -84}, {-69, -54}, {-60, -54}}));
      connect(water.outlet, abs.top_feed) annotation(
        Line(points = {{-80, 66}, {-69, 66}, {-69, 42}, {-60, 42}}));
      connect(abs.top_product, top.inlet) annotation(
        Line(points = {{20, 42}, {38, 42}, {38, 62}, {52, 62}}));
      connect(abs.bottom_product, bottom.inlet) annotation(
        Line(points = {{20, -54}, {36.5, -54}, {36.5, -86}, {60, -86}}));
      water.P = 101325;
      water.T = 325;
      water.totMolFlo[1] = 30;
      water.compMolFrac[1, :] = {0, 0, 1};
      air_acetone.P = 101325;
      air_acetone.T = 335;
      air_acetone.totMolFlo[1] = 30;
      air_acetone.compMolFrac[1, :] = {0.5, 0.5, 0};
    end Test;
  end rigAbs;
end Test;
