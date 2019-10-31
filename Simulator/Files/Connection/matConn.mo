within Simulator.Files.Connection;

connector matConn
  Real P, T, mixMolFlo, mixMolEnth, mixMolEntr, mixMolFrac[3, connNOC], vapPhasMolFrac;
  parameter Integer connNOC;
  annotation(
    Icon(coordinateSystem(initialScale = 0.1), graphics = {Rectangle(lineColor = {0, 70, 70}, fillColor = {0, 70, 70}, fillPattern = FillPattern.Solid, lineThickness = 0.3, extent = {{-50, 50}, {50, -50}})}));
end matConn;
