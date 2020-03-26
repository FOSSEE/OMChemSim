within Simulator.Examples;

package MaterialStream
  extends Modelica.Icons.ExamplesPackage;

  model TPflash
  
    import data = Simulator.Files.ChemsepDatabase;
    parameter data.Methanol meth;
    parameter data.Ethanol eth;
    parameter data.Water wat;
    extends Streams.MaterialStream(Nc = 3, C = {meth, eth, wat});
    extends Simulator.Files.ThermodynamicPackages.RaoultsLaw;
  equation
    P = 101325;
    T = 351;
    x_pc[1, :] = {0.33, 0.33, 0.34};
    F_p[1] = 100;
  annotation(
      Documentation(info = "<html><head></head><body><span style=\"font-size: 12px;\">This is an executable standalone model to simualate the Material Stream example where all the components are defined, material stream specifications are declared.&nbsp;</span><a href=\"modelica://Simulator.Streams.MaterialStream\" style=\"font-size: 12px;\">MaterialStream</a><span style=\"font-size: 12px;\">&nbsp;model from the Streams package has been instantiated here.</span><div><br></div><div><b style=\"font-size: 12px;\">Component System:</b><span style=\"font-size: 12px;\">&nbsp;Methane, Ethane, Water</span><div style=\"font-size: 12px;\"><b>Thermodynamics:</b>&nbsp;Raoult's Law</div><div style=\"font-size: 12px;\"><br></div><div style=\"font-size: 12px;\">This material stream is simulated using TP flash. In other words, Temperature and Pressure conditions are defined along with molar flow rate and mole fraction of the components.</div><div><span style=\"font-size: 12px;\"><br></span></div><div><div style=\"font-size: 12px;\"><b>Material Stream Information</b></div><div style=\"font-size: 12px;\"><br></div><div style=\"font-size: 12px;\"><b>Molar Flow Rate:</b>&nbsp;100 mol/s</div><div style=\"font-size: 12px;\"><b>Mole Fraction (Methane):</b>&nbsp;0.33</div><div style=\"font-size: 12px;\"><b>Mole Fraction (Ethane):</b>&nbsp;0.33</div><div style=\"font-size: 12px;\"><b>Mole Fraction (Water):</b> 0.34</div><div style=\"font-size: 12px;\"><b>Pressure:</b>&nbsp;101325 Pa</div><div style=\"font-size: 12px;\"><b>Temperature:</b>&nbsp;351 K</div></div></div></body></html>"));
      end TPflash;

  model TVFflash
    Simulator.Files.ChemsepDatabase data;
    parameter data.Methanol meth;
    parameter data.Ethanol eth;
    parameter data.Water wat;
    extends Streams.MaterialStream(Nc = 3, C = {meth, eth, wat});
    extends Simulator.Files.ThermodynamicPackages.RaoultsLaw;
  equation
    xvap = 0.036257;
    T = 351;
    x_pc[1, :] = {0.33, 0.33, 0.34};
    F_p[1] = 31.346262;
  annotation(
      Documentation(info = "<html><head></head><body><span style=\"font-size: 12px;\">This is an executable standalone model to simualate the Material Stream example where all the components are defined, material stream specifications are declared.&nbsp;</span><a href=\"modelica://Simulator.Streams.MaterialStream\" style=\"font-size: 12px;\">MaterialStream</a><span style=\"font-size: 12px;\">&nbsp;model from the Streams package has been instantiated here.</span><div><br></div><div><b style=\"font-size: 12px;\">Component System:</b><span style=\"font-size: 12px;\">&nbsp;Methane, Ethane, Water</span><div style=\"font-size: 12px;\"><b>Thermodynamics:</b>&nbsp;Raoult's Law</div><div style=\"font-size: 12px;\"><br></div><div style=\"font-size: 12px;\">This material stream is simulated using TVF flash. In other words, Temperature and Vapor Phase Mole Fraction conditions are defined along with molar flow rate and mole fraction of the components.</div><div><span style=\"font-size: 12px;\"><br></span></div><div><div style=\"font-size: 12px;\"><b>Material Stream Information</b></div><div style=\"font-size: 12px;\"><br></div><div style=\"font-size: 12px;\"><b>Molar Flow Rate:</b>&nbsp;31.346262 mol/s</div><div style=\"font-size: 12px;\"><b>Mole Fraction (Methane):</b>&nbsp;0.33</div><div style=\"font-size: 12px;\"><b>Mole Fraction (Ethane):</b>&nbsp;0.33</div><div style=\"font-size: 12px;\"><b>Mole Fraction (Water):</b> 0.34</div><div style=\"font-size: 12px;\"><b>Vapor Phase Mole Fraction:</b> 0.036257</div><div style=\"font-size: 12px;\"><b>Temperature:</b>&nbsp;351 K</div></div></div></body></html>"));
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
  annotation(
      Documentation(info = "<html><head></head><body><span style=\"font-size: 12px;\">This is an executable standalone model to simualate the Material Stream example where all the components are defined, material stream specifications are declared.&nbsp;</span><a href=\"modelica://Simulator.Streams.MaterialStream\" style=\"font-size: 12px;\">MaterialStream</a><span style=\"font-size: 12px;\">&nbsp;model from the Streams package has been instantiated here.</span><div><br></div><div><b style=\"font-size: 12px;\">Component System:</b><span style=\"font-size: 12px;\">&nbsp;Methane, Ethane, Water</span><div style=\"font-size: 12px;\"><b>Thermodynamics:</b>&nbsp;Raoult's Law</div><div style=\"font-size: 12px;\"><br></div><div style=\"font-size: 12px;\">This material stream is simulated using PVF flash. In other words, Pressure and Vapor Phase Mole Fraction conditions are defined along with molar flow rate and mole fraction of the components.</div><div><span style=\"font-size: 12px;\"><br></span></div><div><div style=\"font-size: 12px;\"><b>Material Stream Information</b></div><div style=\"font-size: 12px;\"><br></div><div style=\"font-size: 12px;\"><b>Molar Flow Rate:</b>&nbsp;100 mol/s</div><div style=\"font-size: 12px;\"><b>Mole Fraction (Methane):</b>&nbsp;0.33</div><div style=\"font-size: 12px;\"><b>Mole Fraction (Ethane):</b>&nbsp;0.33</div><div style=\"font-size: 12px;\"><b>Mole Fraction (Water):</b> 0.34</div><div style=\"font-size: 12px;\"><b>Vapor Phase Mole Fraction:</b> 0.036257</div><div style=\"font-size: 12px;\"><b>Pressure:</b>&nbsp;101325 K</div></div></div></body></html>"));
      end PVFflash;

  model PHflash
    import data = Simulator.Files.ChemsepDatabase;
    parameter data.Methanol meth;
    parameter data.Ethanol eth;
    parameter data.Water wat;
    extends Streams.MaterialStream(Nc = 3, C = {meth, eth, wat});
    extends Simulator.Files.ThermodynamicPackages.RaoultsLaw;
  equation
    P = 101325;
    H_p[1] = -34452;
    x_pc[1, :] = {0.33, 0.33, 0.34};
    F_p[1] = 31.346262;
  annotation(
      Documentation(info = "<html><head></head><body><span style=\"font-size: 12px;\">This is an executable standalone model to simualate the Material Stream example where all the components are defined, material stream specifications are declared.&nbsp;</span><a href=\"modelica://Simulator.Streams.MaterialStream\" style=\"font-size: 12px;\">MaterialStream</a><span style=\"font-size: 12px;\">&nbsp;model from the Streams package has been instantiated here.</span><div><br></div><div><b style=\"font-size: 12px;\">Component System:</b><span style=\"font-size: 12px;\">&nbsp;Methane, Ethane, Water</span><div style=\"font-size: 12px;\"><b>Thermodynamics:</b>&nbsp;Raoult's Law</div><div style=\"font-size: 12px;\"><br></div><div style=\"font-size: 12px;\">This material stream is simulated using PH flash. In other words, Pressure and Enthalpy conditions are defined along with molar flow rate and mole fraction of the components.</div><div><span style=\"font-size: 12px;\"><br></span></div><div><div style=\"font-size: 12px;\"><b>Material Stream Information</b></div><div style=\"font-size: 12px;\"><br></div><div style=\"font-size: 12px;\"><b>Molar Flow Rate:</b>&nbsp;31.346262 mol/s</div><div style=\"font-size: 12px;\"><b>Mole Fraction (Methane):</b>&nbsp;0.33</div><div style=\"font-size: 12px;\"><b>Mole Fraction (Ethane):</b>&nbsp;0.33</div><div style=\"font-size: 12px;\"><b>Mole Fraction (Water):</b> 0.34</div></div></div><div style=\"font-size: 12px;\"><b>Pressure:</b> 101325 Pa</div><div style=\"font-size: 12px;\"><b>Enthalpy:</b> -34452 kJ/kmol</div></body></html>"));
      end PHflash;

  model PSflash
    import data = Simulator.Files.ChemsepDatabase;
    parameter data.Methanol meth;
    parameter data.Ethanol eth;
    parameter data.Water wat;
    extends Streams.MaterialStream(Nc = 3, C = {meth, eth, wat});
    extends Simulator.Files.ThermodynamicPackages.RaoultsLaw;
  equation
    P = 101325;
    S_p[1] = -84.39;
    x_pc[1, :] = {0.33, 0.33, 0.34};
    F_p[1] = 31.346262;
  annotation(
      Documentation(info = "<html><head></head><body><span style=\"font-size: 12px;\">This is an executable standalone model to simualate the Material Stream example where all the components are defined, material stream specifications are declared.&nbsp;</span><a href=\"modelica://Simulator.Streams.MaterialStream\" style=\"font-size: 12px;\">MaterialStream</a><span style=\"font-size: 12px;\">&nbsp;model from the Streams package has been instantiated here.</span><div><br></div><div><b style=\"font-size: 12px;\">Component System:</b><span style=\"font-size: 12px;\">&nbsp;Methane, Ethane, Water</span><div style=\"font-size: 12px;\"><b>Thermodynamics:</b>&nbsp;Raoult's Law</div><div style=\"font-size: 12px;\"><br></div><div style=\"font-size: 12px;\">This material stream is simulated using PS flash. In other words, Pressure and Entropy conditions are defined along with molar flow rate and mole fraction of the components.</div><div><span style=\"font-size: 12px;\"><br></span></div><div><div style=\"font-size: 12px;\"><b>Material Stream Information</b></div><div style=\"font-size: 12px;\"><br></div><div style=\"font-size: 12px;\"><b>Molar Flow Rate:</b>&nbsp;31.346262 mol/s</div><div style=\"font-size: 12px;\"><b>Mole Fraction (Methane):</b>&nbsp;0.33</div><div style=\"font-size: 12px;\"><b>Mole Fraction (Ethane):</b>&nbsp;0.33</div><div style=\"font-size: 12px;\"><b>Mole Fraction (Water):</b> 0.34</div><div style=\"font-size: 12px;\"><b>Pressure:</b>&nbsp;101325 Pa</div><div style=\"font-size: 12px;\"><b>Entropy:</b>&nbsp;-84.39 kJ/[kmol.K]</div></div></div></body></html>"));
      end PSflash;

  model BelBubl "Material Stream below Bubble Point"
    import data = Simulator.Files.ChemsepDatabase;
    parameter data.Methanol meth;
    parameter data.Ethanol eth;
    parameter data.Water wat;
    extends Streams.MaterialStream(Nc = 3, C = {meth, eth, wat});
    extends Simulator.Files.ThermodynamicPackages.RaoultsLaw;
  equation
    P = 202650;
    T = 320;
    x_pc[1, :] = {0.33, 0.33, 0.34};
    F_p[1] = 31.346262;
  annotation(
      Documentation(info = "<html><head></head><body><span style=\"font-size: 12px;\">This is an executable standalone model to simualate the Material Stream example where all the components are defined, material stream specifications are declared.&nbsp;</span><a href=\"modelica://Simulator.Streams.MaterialStream\" style=\"font-size: 12px;\">MaterialStream</a><span style=\"font-size: 12px;\">&nbsp;model from the Streams package has been instantiated here.</span><div><br></div><div><b style=\"font-size: 12px;\">Component System:</b><span style=\"font-size: 12px;\">&nbsp;Methane, Ethane, Water</span><div style=\"font-size: 12px;\"><b>Thermodynamics:</b>&nbsp;Raoult's Law</div><div style=\"font-size: 12px;\"><br></div><div style=\"font-size: 12px;\">This material stream is simulated using TP flash. In other words, Temperature and Vapor Phase Mole Fraction conditions are defined along with molar flow rate and mole fraction of the components.</div><div><span style=\"font-size: 12px;\"><br></span></div><div><div style=\"font-size: 12px;\"><b>Material Stream Information</b></div><div style=\"font-size: 12px;\"><br></div><div style=\"font-size: 12px;\"><b>Molar Flow Rate:</b>&nbsp;31.346262 mol/s</div><div style=\"font-size: 12px;\"><b>Mole Fraction (Methane):</b>&nbsp;0.33</div><div style=\"font-size: 12px;\"><b>Mole Fraction (Ethane):</b>&nbsp;0.33</div><div style=\"font-size: 12px;\"><b>Mole Fraction (Water):</b> 0.34</div><div style=\"font-size: 12px;\"><b>Temperature:</b>&nbsp;320 K</div></div></div><div style=\"font-size: 12px;\"><b>Pressure:</b> 202650 Pa</div></body></html>"));
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
  annotation(
      Documentation(info = "<html><head></head><body><span style=\"font-size: 12px;\">This is an executable standalone model to simualate the Material Stream example where all the components are defined, material stream specifications are declared.&nbsp;</span><a href=\"modelica://Simulator.Streams.MaterialStream\" style=\"font-size: 12px;\">MaterialStream</a><span style=\"font-size: 12px;\">&nbsp;model from the Streams package has been instantiated here.</span><div><br></div><div><b style=\"font-size: 12px;\">Component System:</b><span style=\"font-size: 12px;\">&nbsp;Ethanol, Water</span><div style=\"font-size: 12px;\"><b>Thermodynamics:</b>&nbsp;UNIQUAC</div><div style=\"font-size: 12px;\"><br></div><div style=\"font-size: 12px;\">This material stream is simulated using TP flash and UNIQUAC property package. In other words, Temperature and Pressure conditions are defined along with molar flow rate and mole fraction of the components.</div><div><span style=\"font-size: 12px;\"><br></span></div><div><div style=\"font-size: 12px;\"><b>Material Stream Information</b></div><div style=\"font-size: 12px;\"><br></div><div style=\"font-size: 12px;\"><b>Molar Flow Rate:</b>&nbsp;50 mol/s</div><div style=\"font-size: 12px;\"><b>Mole Fraction (Ethanol):</b>&nbsp;0.5</div><div style=\"font-size: 12px;\"><b>Mole Fraction (Water):</b> 0.5</div><div style=\"font-size: 12px;\"><b>Temperature:</b>&nbsp;354 K</div></div></div><div style=\"font-size: 12px;\"><b>Pressure:</b> 101325 Pa</div></body></html>"));
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
  annotation(
      Documentation(info = "<html><head></head><body><span style=\"font-size: 12px;\">This is an executable standalone model to simualate the Material Stream example where all the components are defined, material stream specifications are declared.&nbsp;</span><a href=\"modelica://Simulator.Streams.MaterialStream\" style=\"font-size: 12px;\">MaterialStream</a><span style=\"font-size: 12px;\">&nbsp;model from the Streams package has been instantiated here.</span><div><br></div><div><b style=\"font-size: 12px;\">Component System:</b><span style=\"font-size: 12px;\">&nbsp;Ethanol, 1-Hexane</span><div style=\"font-size: 12px;\"><b>Thermodynamics:</b>&nbsp;NRTL</div><div style=\"font-size: 12px;\"><br></div><div style=\"font-size: 12px;\">This material stream is simulated using TP flash and NRTL property package. In other words, Temperature and Pressure conditions are defined along with molar flow rate and mole fraction of the components.</div><div><span style=\"font-size: 12px;\"><br></span></div><div><div style=\"font-size: 12px;\"><b>Material Stream Information</b></div><div style=\"font-size: 12px;\"><br></div><div style=\"font-size: 12px;\"><b>Molar Flow Rate:</b>&nbsp;100 mol/s</div><div style=\"font-size: 12px;\"><b>Mole Fraction (Ethanol):</b>&nbsp;0.5</div><div style=\"font-size: 12px;\"><b>Mole Fraction (1-Hexane):</b> 0.5</div><div style=\"font-size: 12px;\"><b>Temperature:</b>&nbsp;330 K</div></div></div><div style=\"font-size: 12px;\"><b>Pressure:</b> 101325 Pa</div></body></html>"));
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
  annotation(
      Documentation(info = "<html><head></head><body><span style=\"font-size: 12px;\">This is an executable standalone model to simualate the Material Stream example where all the components are defined, material stream specifications are declared.&nbsp;</span><a href=\"modelica://Simulator.Streams.MaterialStream\" style=\"font-size: 12px;\">MaterialStream</a><span style=\"font-size: 12px;\">&nbsp;model from the Streams package has been instantiated here.</span><div><br></div><div><b style=\"font-size: 12px;\">Component System:</b><span style=\"font-size: 12px;\">&nbsp;Ethylene, Acetylene, 1,1-Dichloroethane, Propadiene</span><div style=\"font-size: 12px;\"><b>Thermodynamics:</b>&nbsp;Grayson Streed</div><div style=\"font-size: 12px;\"><br></div><div style=\"font-size: 12px;\"><div><div>This material stream is simulated using TP flash and Grayson-Streed property package. In other words, Temperature and Pressure conditions are defined along with molar flow rate and mole fraction of the components. Grayson-Streed parameters are also defined here.</div><div><br></div><div><div><b>Material Stream Information</b></div><div><br></div><div><b>Molar Flow Rate:</b>&nbsp;100 mol/s</div><div><b>Mole Fraction (Ethylene):</b>&nbsp;0.4</div><div><b>Mole Fraction (Acetylene):</b>&nbsp;0.3</div><div><b>Mole Fraction (1,1-Dichloroethane):</b>&nbsp;0.2</div><div><b>Mole Fraction (Propadiene):</b>&nbsp;0.1</div><div><b>Temperature:</b>&nbsp;210.246 K</div></div></div><div><b>Pressure:</b>&nbsp;101325 Pa</div></div></div></body></html>"));
      end GraysonStreed;
  annotation(
    Documentation(info = "<html><head></head><body>This is a package consisting of examples demonstrating different ways in which a material stream can be defined and simulated. Following are the different examples of material stream simulation which are available in this package:<div><br></div><div><ol><li><a href=\"modelica://Simulator.Examples.MaterialStream.TPflash\" style=\"font-size: 12px;\">TPflash</a>: C<span style=\"font-size: 12px;\">reated to simulate a material stream with Raoults Law when temperature and pressure conditions are known</span></li><li><a href=\"modelica://Simulator.Examples.MaterialStream.TVFflash\" style=\"font-size: 12px;\">TVFflash</a>:&nbsp;C<span style=\"font-size: 12px;\">reated to simulate a material stream with Raoults Law when temperature and vapor phase mole fraction conditions are known</span></li><li><a href=\"modelica://Simulator.Examples.MaterialStream.PVFflash\" style=\"font-size: 12px;\">PVFflash</a>:&nbsp;C<span style=\"font-size: 12px;\">reated to simulate a material stream with Raoults Law when pressure and vapor phase mole fraction conditions are known</span></li><li><a href=\"modelica://Simulator.Examples.MaterialStream.PHflash\" style=\"font-size: 12px;\">PHflash</a>:&nbsp;C<span style=\"font-size: 12px;\">reated to simulate a material stream with Raoults Law when pressure and enthalpy conditions are known</span></li><li><a href=\"modelica://Simulator.Examples.MaterialStream.PSflash\" style=\"font-size: 12px;\">PSflash</a>:&nbsp;C<span style=\"font-size: 12px;\">reated to simulate a material stream with Raoults Law when pressure and entropy conditions are known</span></li><li><a href=\"modelica://Simulator.Examples.MaterialStream.BelBubl\" style=\"font-size: 12px;\">BelBubl</a>:&nbsp;C<span style=\"font-size: 12px;\">reated to simulate a material stream with Raoults Law when temperature and vapor phase mole fraction conditions are known</span></li><li><a href=\"modelica://Simulator.Examples.MaterialStream.UNIQUAC\" style=\"font-size: 12px;\">UNIQUAC</a>:&nbsp;C<span style=\"font-size: 12px;\">reated to simulate a material stream with UNIQUAC when temperature and pressure conditions are known</span></li><li><a href=\"modelica://Simulator.Examples.MaterialStream.NRTL\" style=\"font-size: 12px;\">NRTL</a>:&nbsp;C<span style=\"font-size: 12px;\">reated to simulate a material stream with NRTL when temperature and pressure conditions are known</span></li><li><a href=\"modelica://Simulator.Examples.MaterialStream.GraysonStreed\" style=\"font-size: 12px;\">GraysonStreed</a>:&nbsp;C<span style=\"font-size: 12px;\">reated to simulate a material stream with Grayson-Streed when temperature and pressure conditions are known. Grayson Streed parameters are also defined.</span></li></ol></div><div><br></div><div>NOTE: Please note that these examples are standalone examples of material stream. This should be followed only when a material stream is to be simulated separately. For examples on how to instantiate a material stream to be incorporated in a flowsheet, refer to the example <a href=\"modelica://Simulator.Examples.CompositeMS\" style=\"font-size: 12px;\">CompositeMS</a>.</div></body></html>"));
end MaterialStream;
