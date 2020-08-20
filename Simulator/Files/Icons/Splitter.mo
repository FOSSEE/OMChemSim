within Simulator.Files.Icons;

model Splitter "Basic graphical representation of Splitter"

annotation(
    Icon(coordinateSystem(initialScale = 0.1), graphics = {Polygon(origin = {-1, 1}, rotation = 180, lineColor = {0, 70, 70}, fillColor = {19, 224, 255}, lineThickness = 0.3, points = {{-100, 100}, {0, 100}, {100, 0}, {0, -100}, {-100, -100}, {-100, 100}}), Text(extent = {{-500, -120}, {500, -180}}, textString = "%name", fontSize = 10)}),
  Documentation(info = "<html>
<p>
Model that has only basic icon for splitter unit operation (No declarations and no equations).
</p>
</html>"));
end Splitter;
