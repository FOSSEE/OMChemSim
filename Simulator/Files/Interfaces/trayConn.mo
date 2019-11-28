within Simulator.Files.Interfaces;

connector trayConn
   Real F, H, x_c[Nc];
    parameter Integer Nc;
  annotation(
    Icon(coordinateSystem(initialScale = 0.1), graphics = {Rectangle(fillColor = {8, 184, 211}, fillPattern = FillPattern.Solid, extent = {{-50, 50}, {50, -50}})}));
end trayConn;
