within Simulator.Files.Connection;

connector trayConn
  Real mixMolFlo, mixMolEnth, mixMolFrac[connNOC];
  parameter Integer connNOC;
  annotation(
    Icon(coordinateSystem(initialScale = 0.1), graphics = {Rectangle(fillColor = {8, 184, 211}, fillPattern = FillPattern.Solid, extent = {{-50, 50}, {50, -50}})}));
end trayConn;
