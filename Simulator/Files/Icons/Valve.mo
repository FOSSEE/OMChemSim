within Simulator.Files.Icons;

model Valve "Basic graphical representation of Valve"

annotation(
    Icon(graphics = {Polygon(origin = {0, -4}, lineColor = {0, 70, 70}, lineThickness = 0.3, points = {{-100, 66}, {-100, -66}, {100, 66}, {100, -66}, {-100, 66}}), Text(extent = {{-500, -86}, {500, -146}}, textString = "%name", fontSize = 10)}, coordinateSystem(initialScale = 0.1)),
  Documentation(info = "<html>
<p>
Model that has only basic icon for valve unit operation (No declarations and no equations).
</p>
</html>"));
end Valve;
