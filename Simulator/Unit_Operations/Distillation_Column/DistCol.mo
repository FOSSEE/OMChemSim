within Simulator.Unit_Operations.Distillation_Column;

  model DistCol
    extends Simulator.Files.Icons.Distillation_Column;
    parameter Integer Nc;
    import data = Simulator.Files.Chemsep_Database;
    parameter Simulator.Files.Chemsep_Database.General_Properties C[Nc];
    parameter Boolean Bin_t[Nt] = Simulator.Files.Other_Functions.colBoolCalc(Nt, Ni, In_s);
    parameter Integer Nt = 4, Nout = 0, NQ = 0, Ni = 1, InT_s[Ni];
    parameter String Ctype = "Total";
    //Total or Partial
    Real RR(min = 0);
    Simulator.Files.Connection.matConn In_s[Ni](each connNOC = Nc) annotation(
      Placement(visible = true, transformation(origin = {-248, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-250, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Simulator.Files.Connection.matConn Dist(connNOC = Nc) annotation(
      Placement(visible = true, transformation(origin = {250, 316}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {250, 298}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Simulator.Files.Connection.matConn Bot(connNOC = Nc) annotation(
      Placement(visible = true, transformation(origin = {250, -296}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {252, -300}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Simulator.Files.Connection.enConn Cduty annotation(
      Placement(visible = true, transformation(origin = {246, 590}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {250, 600}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Simulator.Files.Connection.enConn Rduty annotation(
      Placement(visible = true, transformation(origin = {252, -588}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {250, -598}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Simulator.Files.Connection.matConn Out_s[Nout](each connNOC = Nc) annotation(
      Placement(visible = true, transformation(origin = {-36, 32}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-70, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Simulator.Files.Connection.enConn En[NQ](each connNOC = Nc) annotation(
      Placement(visible = true, transformation(origin = {-34, -54}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-70, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  equation
  for i in 1:Ni loop
      if InT_s[i] == 1 then
        connect(In_s[i], condensor.In);
      elseif InT_s[i] == Nt then
        connect(In_s[i], reboiler.In);
      elseif InT_s[i] > 1 and InT_s[i] < Nt then
//this is adjustment done since OpenModelica 1.11 is not handling array modification properly
        In_s[i].P = tray[InT_s[i] - 1].Pdmy1;
        In_s[i].T = tray[InT_s[i] - 1].Tdmy1;
        In_s[i].mixMolFlo = tray[InT_s[i] - 1].Fdmy1;
        In_s[i].mixMolFrac = tray[InT_s[i] - 1].xdmy_pc1;
        In_s[i].mixMolEnth = tray[InT_s[i] - 1].Hdmy1;
        In_s[i].mixMolEntr = tray[InT_s[i] - 1].Sdmy1;
        In_s[i].vapPhasMolFrac = tray[InT_s[i] - 1].xvapdmy1;
      end if;
    end for;
    connect(condensor.Out, Dist);
    connect(reboiler.Out, Bot);
    connect(condensor.En, Cduty);
    connect(reboiler.En, Rduty);
    for i in 1:Nt - 3 loop
      connect(tray[i].Out_Liq, tray[i + 1].Out_Liq);
      connect(tray[i].In_Vap, tray[i + 1].Out_Vap);
    end for;
    connect(tray[1].Out_Vap, condensor.In_Vap);
    connect(condensor.Out_Liq, tray[1].In_Liq);
    connect(tray[Nt - 2].Out_Liq, reboiler.In_Liq);
    connect(reboiler.Out_Vap, tray[Nt - 2].In_Vap);
//tray pressures
    for i in 1:Nt - 2 loop
      tray[i].P = condensor.P + i * (reboiler.P - condensor.P) / (Nt - 1);
    end for;
    
    for i in 2:Nt - 1 loop
      tray[i - 1].OutType = "Null";
      tray[i - 1].Out.x_pc = zeros(3, Nc);
      tray[i - 1].Out.F = 0;
      tray[i - 1].Out.H = 0;
      tray[i - 1].Out.S = 0;
      tray[i - 1].Out.xvap = 0;
      tray[i - 1].Q = 0;
    end for;
    RR = condensor.Fliqout / condensor.Out.F;
  annotation(
      Icon(coordinateSystem(extent = {{-250, -600}, {250, 600}})),
      Diagram(coordinateSystem(extent = {{-250, -600}, {250, 600}})),
      __OpenModelica_commandLineOptions = "");
  end DistCol;
