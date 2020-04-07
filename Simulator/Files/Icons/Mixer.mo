within Simulator.Files.Icons;

model Mixer "Basic graphical repesentation of Mixer"

  annotation(
    Icon(coordinateSystem(initialScale = 0.1), graphics = {Polygon(origin = {-1, 1}, lineColor = {0, 70, 70}, fillColor = {19, 224, 255}, lineThickness = 0.3, points = {{-100, 100}, {0, 100}, {100, 0}, {0, -100}, {-100, -100}, {-100, 100}}), Text(origin = {-12, 16}, extent = {{-500, -120}, {500, -180}}, textString = "%name", fontSize = 10)}),
  Documentation(info = "<html>
<p>
Model that has only basic icon for mixer unit operation (No declarations and no equations).
</p>
</html>"));
end Mixer;
