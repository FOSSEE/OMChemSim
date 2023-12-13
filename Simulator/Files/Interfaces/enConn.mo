within Simulator.Files.Interfaces;

connector enConn "Connector to connect energy stream with unit operation"
  Real Q;
  Integer Nc;
  annotation(
    Icon(coordinateSystem(initialScale = 0.1), graphics = {Rectangle(lineColor = {255, 0, 0}, fillColor = {255, 0, 0}, fillPattern = FillPattern.Solid, extent = {{-50, 50}, {50, -50}})}));
end enConn;
