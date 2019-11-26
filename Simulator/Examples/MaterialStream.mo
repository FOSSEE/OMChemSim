within Simulator.Examples;

package MaterialStream
  extends Modelica.Icons.ExamplesPackage;

  model TPflash
  
    //we have to first instance components to give to material stream model.
    import data = Simulator.Files.ChemsepDatabase;
    //instantiation of chemsep database
    parameter data.Methanol meth;
    //instantiation of methanol
    parameter data.Ethanol eth;
    //instantiation of ethanol
    parameter data.Water wat;
    //instantiation of water
    extends Streams.MaterialStream(Nc = 3, C = {meth, eth, wat});
    //material stream model is extended and values of parameters Nc and comp are given. These parameters are declared in Material stream model. We are only giving them values here.
    //Nc - number of components, comp -  component array.
    //start values are given for convergence
    extends Simulator.Files.ThermodynamicPackages.RaoultsLaw;
    //Thermodynamic package is extended. We can use other thermodynamics also(not yet added) after little modification and inclusion of residual properties equations.
  equation
//These are the values to be specified by user. In this P, T, mixture mole fraction and mixture molar flow is specified. These variables are declared in Material stream model, only values are given here.
    P = 101325;
    T = 351;
    x_pc[1, :] = {0.33, 0.33, 0.34};
    F_p[1] = 100;
  end TPflash;

  model TVFflash
    // database and components are instantiated, material stream and thermodynamic package extended
    Simulator.Files.ChemsepDatabase data;
    parameter data.Methanol meth;
    parameter data.Ethanol eth;
    parameter data.Water wat;
    extends Streams.MaterialStream(Nc = 3, C = {meth, eth, wat});
    //Nc - number of components, comp -  component array.
    extends Simulator.Files.ThermodynamicPackages.RaoultsLaw;
  equation
//Here vapor phase mole fraction, temperature, mixture component mole fraction and mixture molar flow is given.
    xvap = 0.036257;
    T = 351;
    x_pc[1, :] = {0.33, 0.33, 0.34};
    F_p[1] = 31.346262;
  end TVFflash;

  model PVFflash
    import data = Simulator.Files.ChemsepDatabase;
    parameter data.Methanol meth;
    parameter data.Ethanol eth;
    parameter data.Water wat;
    extends Streams.MaterialStream(Nc = 3, C = {meth, eth, wat});
    extends Simulator.Files.ThermodynamicPackages.RaoultsLaw;
  equation
    P = 101325;
    xvap = 0.036257;
    x_pc[1, :] = {0.33, 0.33, 0.34};
    F_p[1] = 100;
  end PVFflash;

  model PHflash
    //we have to first instance components to give to material stream model.
    import data = Simulator.Files.ChemsepDatabase;
    //instantiation of chemsep database
    parameter data.Methanol meth;
    //instantiation of methanol
    parameter data.Ethanol eth;
    //instantiation of ethanol
    parameter data.Water wat;
    //instantiation of water
    extends Streams.MaterialStream(Nc = 3, C = {meth, eth, wat});
    //material stream model is extended and values of parameters NOC and comp are given. These parameters are declred in Material stream model. We are only giving them values here.
    //we need to give proper initialization values for converging, Initialization values are provided for totMolFlo, compMolFrac and T while extending.
    //NOC - number of components, comp -  component array.
    extends Simulator.Files.ThermodynamicPackages.RaoultsLaw;
    //Thermodynamic package is extended. We can use other thermodynamics also(not yet added) after little modification and inclusion of residual properties equations.
  equation
//These are the values to be specified by user. In this P, mixture molar enthalpy, mixture mole fraction and mixture molar flow is specified. These variables are declared in Material stream model, only values are given here.
    P = 101325;
    H_p[1] = -34452;
    x_pc[1, :] = {0.33, 0.33, 0.34};
//1 stands for mixture
    F_p[1] = 31.346262;
//1 stands for mixture
  end PHflash;

  model PSflash
    //we have to first instance components to give to material stream model.
    import data = Simulator.Files.ChemsepDatabase;
    //instantiation of chemsep database
    parameter data.Methanol meth;
    //instantiation of methanol
    parameter data.Ethanol eth;
    //instantiation of ethanol
    parameter data.Water wat;
    //instantiation of water
    extends Streams.MaterialStream(Nc = 3, C = {meth, eth, wat});
    //material stream model is extended and values of parameters NOC and comp are given. These parameters are declred in Material stream model. We are only giving them values here.
    //we need to give proper initialization values for converging, Initialization values are provided for totMolFlo, compMolFrac and T while extending.
    //NOC - number of components, comp -  component array.
    extends Simulator.Files.ThermodynamicPackages.RaoultsLaw;
    //Thermodynamic package is extended. We can use other thermodynamics also(not yet added) after little modification and inclusion of residual properties equations.
  equation
//These are the values to be specified by user. In this P, mixture molar enthalpy, mixture mole fraction and mixture molar flow is specified. These variables are declared in Material stream model, only values are given here.
    P = 101325;
    S_p[1] = -84.39;
    x_pc[1, :] = {0.33, 0.33, 0.34};
//1 stands for mixture
    F_p[1] = 31.346262;
//1 stands for mixture
  end PSflash;

  model BelBubl "material stream below bubble point"
    //we have to first instance components to give to material stream model.
    import data = Simulator.Files.ChemsepDatabase;
    //instantiation of chemsep database
    parameter data.Methanol meth;
    //instantiation of methanol
    parameter data.Ethanol eth;
    //instantiation of ethanol
    parameter data.Water wat;
    //instantiation of water
    extends Streams.MaterialStream(Nc = 3, C = {meth, eth, wat});
    //material stream model is extended and values of parameters NOC and comp are given. These parameters are declared in Material stream model. We are only giving them values here.
    //NOC - number of components, comp -  component array.
    extends Simulator.Files.ThermodynamicPackages.RaoultsLaw;
    //Thermodynamic package is extended. We can use other thermodynamics also(not yet added) after little modification and inclusion of residual properties equations.
  equation
//These are the values to be specified by user. In this P, T, mixture mole fraction and mixture molar flow is specified. These variables are declared in Material stream model, only values are given here.
    P = 202650;
    T = 320;
    x_pc[1, :] = {0.33, 0.33, 0.34};
//1 stands for mixture
    F_p[1] = 31.346262;
//1 stands for mixture
  end BelBubl;

  model UNIQUAC
    import data = Simulator.Files.ChemsepDatabase;
    parameter data.Ethanol eth;
    parameter data.Water wat;
    extends Simulator.Streams.MaterialStream(Nc = 2, C = {eth, wat}, Pbubl(start = 101325), Pdew(start = 101325), x_pc(each start = 0.33), xvap(start = 0.68));
    extends Simulator.Files.ThermodynamicPackages.UNIQUAC;
  equation
    x_pc[1, :] = {0.5, 0.5};
    F_p[1] = 50;
    P = 101325;
    T = 354;
  end UNIQUAC;

  model NRTL
    import data = Simulator.Files.ChemsepDatabase;
    parameter data.Onehexene ohex;
    parameter data.Ethanol eth;
    extends Simulator.Streams.MaterialStream(Nc = 2, C = {ohex, eth}, x_pc(each start = 0.33));
    extends Simulator.Files.ThermodynamicPackages.NRTL;
  equation
    x_pc[1, :] = {0.5, 0.5};
    F_p[1] = 100;
    P = 101325;
    T = 330;
  end NRTL;

  model GraysonStreed
    import data = Simulator.Files.ChemsepDatabase;
    parameter data.Ethylene eth;
    parameter data.Acetylene acet;
    parameter data.OneOnedichloroethane dich;
    parameter data.Propadiene prop;
    //w=Acentric Factor
    //Sp = Solublity Parameter
    //V = Molar Volume
    //All the above three parameters have to be mentioned as arguments while extending the thermodynamic Package Grayson Streed  as shown below
    extends Simulator.Files.ThermodynamicPackages.GraysonStreed(W_c = {0.0949, 0.1841, 0.244612, 0.3125}, SP_c = {0.00297044, 0.00449341, 0.00437069, 0.00419199}, V_c = {61, 42.1382, 84.7207, 60.4292});
    extends Simulator.Streams.MaterialStream(Nc = 4, C = {eth, acet, dich, prop});
    //Equations
  equation
    P = 101325;
    T = 210.246;
    x_pc[1, :] = {0.4, 0.2, 0.3, 0.1};
    F_p[1] = 50;
  end GraysonStreed;
end MaterialStream;
