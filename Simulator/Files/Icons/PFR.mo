within Simulator.Files.Icons;

model PFR "Basic graphical representation of Plug Flow Reactor"

annotation(
    Icon(coordinateSystem(extent = {{-350, -100}, {350, 100}}, initialScale = 0.1), graphics = {Line(points = {{-320, 70}, {320, 70}}, color = {0, 70, 70}, thickness = 0.3), Line(points = {{-320, -70}, {320, -70}}, color = {0, 70, 70}, thickness = 0.3), Text(extent = {{-500, -90}, {500, -150}}, textString = "%name", fontSize = 10), Line(points = {{-250, 70}, {-250, -70}}, color = {0, 70, 70}, thickness = 0.3), Line(points = {{250, 70}, {250, -70}}, color = {0, 70, 70}, thickness = 0.3), Line(points = {{-320, 70}, {-350, 30}, {-350, -30}, {-320, -70}}, color = {0, 70, 70}, thickness = 0.3, smooth = Smooth.Bezier), Line(rotation = 180, points = {{-320, 70}, {-350, 30}, {-350, -30}, {-320, -70}}, color = {0, 70, 70}, thickness = 0.3, smooth = Smooth.Bezier), Line(points = {{-250, 70}, {-200, -70}, {-150, 70}, {-100, -70}, {-50, 70}, {0, -70}, {50, 70}, {100, -70}, {150, 70}, {200, -70}, {250, 70}}, color = {0, 70, 70}, thickness = 0.3), Line(rotation = 180, points = {{-250, 70}, {-200, -70}, {-150, 70}, {-100, -70}, {-50, 70}, {0, -70}, {50, 70}, {100, -70}, {150, 70}, {200, -70}, {250, 70}}, color = {0, 70, 70}, thickness = 0.3)}),
    Diagram(coordinateSystem(extent = {{-350, -100}, {350, 100}})),
    __OpenModelica_commandLineOptions = "",
  Documentation(info = "<html>
<p>
Model that has only basic icon for plug flow reactor unit operation (No declarations and no equations).
</p>
</html>"));
end PFR;
