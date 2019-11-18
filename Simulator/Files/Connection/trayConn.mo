within Simulator.Files.Connection;

connector trayConn
   Real F(min = 0, start = 100), H, x_pc[Nc](each min = 0, each max = 1, each start = 1/(Nc + 1));
    parameter Integer Nc;
  annotation(
    Icon(coordinateSystem(initialScale = 0.1), graphics = {Rectangle(fillColor = {8, 184, 211}, fillPattern = FillPattern.Solid, extent = {{-50, 50}, {50, -50}})}));
end trayConn;
