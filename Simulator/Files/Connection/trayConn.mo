within Simulator.Files.Connection;

connector trayConn
  Real mixMolFlo(min = 0, start = 100), mixMolEnth, mixMolFrac[connNOC](each min = 0, each max = 1, each start = 1 / (connNOC + 1));
  parameter Integer connNOC;
  annotation(
    Icon(coordinateSystem(initialScale = 0.1), graphics = {Rectangle(fillColor = {8, 184, 211}, fillPattern = FillPattern.Solid, extent = {{-100, 100}, {100, -100}})}));
end trayConn;
