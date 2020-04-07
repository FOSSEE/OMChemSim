within Simulator.Files.Icons;

model AdiabaticExpander "Basic graphical representation of Adiabatic Expander"

  annotation(
    Icon(graphics = {Polygon(lineColor = {0, 70, 70}, lineThickness = 0.3, points = {{-100, 50}, {100, 80}, {100, -80}, {-100, -50}, {-100, 50}}), Text(extent = {{-500, -100}, {500, -160}}, textString = "%name", fontSize = 10)}, coordinateSystem(initialScale = 0.1)),
  Documentation(info = "<html>
<p>
Model that has only basic icon for adiabatic expander unit operation (No declarations and no equations).
</p>
</html>"));
end AdiabaticExpander;
