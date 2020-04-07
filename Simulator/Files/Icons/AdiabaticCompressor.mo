within Simulator.Files.Icons;

model AdiabaticCompressor "Basic graphical representation of Adiabatic Compressor"
equation

annotation(
    Icon(graphics = {Polygon(lineColor = {0, 70, 70},lineThickness = 0.3, points = {{-100, 80}, {100, 50}, {100, -50}, {-100, -80}, {-100, 80}}), Text(extent = {{-500, -100}, {500, -160}}, textString = "%name", fontSize = 10)}, coordinateSystem(initialScale = 0.1)),
  Documentation(info = "<html>
<p>
Model that has only basic icon for adiabatic compressor unit operation (No declarations and no equations).
</p>
</html>"));
end AdiabaticCompressor;
