within Simulator.Files.Connection;

connector matConn
 Real P(min = 0, start = 101325), T(min = 0, start = 273.15), F(min = 0, start = 100), H, S,x_pc[3, Nc](each min = 0, each max = 1, each start = 1/(Nc + 1)), xvap(min = 0, max = 1, start = 0.5);
    parameter Integer Nc(start = 2);
  annotation(
    Icon(coordinateSystem(initialScale = 0.1), graphics = {Rectangle(lineColor = {0, 70, 70}, fillColor = {0, 70, 70}, fillPattern = FillPattern.Solid, extent = {{-50, 50}, {50, -50}})}));
end matConn;
