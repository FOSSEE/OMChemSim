within Simulator.Files.Icons;

model MaterialStream

annotation(
    Icon(coordinateSystem(initialScale = 0.1), graphics = {Line(points = {{-100, 0}, {100, 0}}, color = {0, 70, 70}, thickness = 0.3), Line(points = {{80, 20}, {100, 0}, {80, -20}}, color = {0, 70, 70}, thickness = 0.3), Text(extent = {{-500, -40}, {500, -100}}, textString = "%name", fontSize = 10)}));

end MaterialStream;
