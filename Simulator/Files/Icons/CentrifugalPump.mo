within Simulator.Files.Icons;

model CentrifugalPump
equation

annotation(
    Icon(graphics = {Ellipse(origin = {0, 15}, lineColor = {0, 70, 70}, lineThickness = 0.3, extent = {{-85, 85}, {85, -85}}, endAngle = 360), Line(origin = {-66, -60}, points = {{0, 0}, {0, 0}}), Line(points = {{0, 100}, {100, 100}}, color = {0, 70, 70}, thickness = 0.3), Rectangle(lineColor = {0, 70, 70}, lineThickness = 0.3, extent = {{-90, -80}, {90, -100}}), Line(points = {{-100, 15}, {0, 15}}, color = {0, 70, 70}, thickness = 0.3), Text(extent = {{-500, -120}, {500, -180}}, textString = "%name", fontSize = 10)}, coordinateSystem(initialScale = 0.1)));end CentrifugalPump;
