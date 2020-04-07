within Simulator.Files.Icons;

model EquilibriumReactor "Basic graphical representation of Equilibrium Reactor"

annotation(
    Icon(coordinateSystem(extent = {{-100, -200}, {100, 200}}, initialScale = 0.1), graphics = {Line(points = {{-100, 120}, {-100, -120}}, color = {0, 70, 70}, thickness = 0.3), Line(origin = {100, 0}, points = {{0, 120}, {0, -120}}, color = {0, 70, 70}, thickness = 0.3), Line(origin = {0, 150}, points = {{-100, 0}, {-85, 20}, {-40, 40}, {40, 40}, {85, 20}, {100, 0}}, color = {0, 70, 70}, thickness = 0.3, smooth = Smooth.Bezier), Rectangle(origin = {0, 125}, lineColor = {0, 70, 70}, lineThickness = 0.3, extent = {{-120, 5}, {120, -5}}), Rectangle(origin = {0, -125}, lineColor = {0, 70, 70}, lineThickness = 0.3, extent = {{-120, 5}, {120, -5}}), Text(extent = {{-500, -220}, {500, -280}}, textString = "%name", fontSize = 10), Line(origin = {-100, 0}, points = {{0, 130}, {0, 150}}, color = {0, 70, 70}, thickness = 0.3), Line(origin = {100, 0}, points = {{0, 130}, {0, 150}}, color = {0, 70, 70}, thickness = 0.3), Line(origin = {-100, 0}, points = {{0, -130}, {0, -150}}, color = {0, 70, 70}, thickness = 0.3), Line(origin = {100, 0}, points = {{0, -130}, {0, -150}}, color = {0, 70, 70}, thickness = 0.3), Line(origin = {0, -150}, rotation = 180, points = {{-100, 0}, {-85, 20}, {-40, 40}, {40, 40}, {85, 20}, {100, 0}}, color = {0, 70, 70}, thickness = 0.3, smooth = Smooth.Bezier), Line(origin = {-40.3471, 0.677686}, points = {{0, 60}, {0, -60}}), Line(origin = {0, 60}, points = {{-40, 0}, {40, 0}}), Line(points = {{-40, 0}, {40, 0}}), Line(origin = {0, -59}, points = {{-40, -1}, {40, -1}})}),
    __OpenModelica_commandLineOptions = "",
    Diagram(coordinateSystem(extent = {{-100, -200}, {100, 200}})),
  Documentation(info = "<html>
<p>
Model that has only basic icon for equilibrium reactor unit operation (No declarations and no equations).
</p>
</html>"));
end EquilibriumReactor;
