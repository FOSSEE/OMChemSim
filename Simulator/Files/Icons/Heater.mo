within Simulator.Files.Icons;

model Heater
  annotation(
    Diagram,
    Icon(graphics = {Ellipse(lineColor = {0, 70, 70}, lineThickness = 0.3,extent = {{-100, 100}, {100, -100}}, endAngle = 360), Line(points = {{-100, -100}, {100, 100}}, color = {255, 0, 0}, thickness = 0.3), Line(origin = {90, 90}, points = {{-10, 10}, {10, 10}, {10, -10}}, color = {255, 0, 0}, thickness = 0.3), Text(lineColor = {0, 70, 70},extent = {{-50, 50}, {50, -50}}, textString = "H", textStyle = {TextStyle.Bold}), Text( extent = {{-500, -120}, {500, -180}}, textString = "%name", fontSize = 10)}, coordinateSystem(initialScale = 0.1)));
end Heater;
