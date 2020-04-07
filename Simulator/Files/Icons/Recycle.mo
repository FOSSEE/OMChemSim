within Simulator.Files.Icons;

model Recycle "Basic graphical representation of Recycle block"

 annotation(
    Icon(graphics = {Ellipse(lineColor = {0, 70, 70}, lineThickness = 0.3,extent = {{-100, 100}, {100, -100}}, endAngle = 360),  Text(extent = {{-500, -120}, {500, -180}}, textString = "%name", fontSize = 10), Line(origin = {-20.2149, 10.1322}, points = {{0, 50}, {0, -70}}),   Ellipse(origin = {-20, 20}, rotation = 180, extent = {{-60, 40}, {60, -40}}, startAngle = 270, endAngle = 90), Line(origin = {20, -39}, points = {{-20, 21}, {20, -21}})}, coordinateSystem(initialScale = 0.1)),
    Documentation(info = "<html>
<p>
Model that has only basic icon for recycle block (No declarations and no equations).
</p>
</html>"));

end Recycle;
