within Simulator.Files;

package Icons
  model Mixer
    annotation(
      Icon(coordinateSystem(initialScale = 0.1), graphics = {Polygon(origin = {-1, 1}, lineColor = {0, 70, 70}, fillColor = {19, 224, 255}, lineThickness = 0.3, points = {{-100, 100}, {0, 100}, {100, 0}, {0, -100}, {-100, -100}, {-100, 100}}), Text(extent = {{-500, -120}, {500, -180}}, textString = "%name", fontSize = 50)}));
  end Mixer;

  model Heater
    annotation(
      Diagram,
      Icon(graphics = {Ellipse(lineColor = {0, 70, 70}, lineThickness = 0.3, extent = {{-100, 100}, {100, -100}}, endAngle = 360), Line(points = {{-100, -100}, {100, 100}}, color = {255, 0, 0}, thickness = 0.3), Line(origin = {90, 90}, points = {{-10, 10}, {10, 10}, {10, -10}}, color = {255, 0, 0}, thickness = 0.3), Text(lineColor = {0, 70, 70}, extent = {{-50, 50}, {50, -50}}, textString = "H", textStyle = {TextStyle.Bold}), Text(extent = {{-500, -120}, {500, -180}}, textString = "%name", fontSize = 50)}, coordinateSystem(initialScale = 0.1)));
  end Heater;

  model Heat_Exchanger
    annotation(
      Icon(graphics = {Ellipse(lineColor = {0, 70, 70}, lineThickness = 0.3, extent = {{-100, 100}, {100, -100}}, endAngle = 360), Line(points = {{-100, 0}, {-35, 30}, {35, -30}, {100, 0}}, color = {0, 70, 70}, thickness = 0.3), Text(extent = {{-500, -120}, {500, -180}}, textString = "%name", fontSize = 50)}, coordinateSystem(initialScale = 0.1)));
  end Heat_Exchanger;

  model Cooler
  equation

    annotation(
      Icon(graphics = {Ellipse(origin = {-1, 2}, lineColor = {0, 70, 70}, lineThickness = 0.3, extent = {{-100, 100}, {100, -100}}, endAngle = 360), Line(origin = {-1.21, 0.36}, points = {{-100, 100}, {100, -100}}, color = {255, 0, 0}, thickness = 0.3), Line(origin = {90, -90}, points = {{10, 10}, {10, -10}, {-10, -10}}, color = {255, 0, 0}, thickness = 0.3), Text(origin = {-3, -5}, lineColor = {0, 70, 70}, extent = {{-50, 50}, {50, -50}}, textString = "C", textStyle = {TextStyle.Bold}), Text(extent = {{-500, -120}, {500, -180}}, textString = "%name", fontSize = 50)}, coordinateSystem(initialScale = 0.1)));
  end Cooler;

  model Valve
  equation

    annotation(
      Icon(graphics = {Polygon(origin = {0, -4}, lineColor = {0, 70, 70}, lineThickness = 0.3, points = {{-100, 66}, {-100, -66}, {100, 66}, {100, -66}, {-100, 66}}), Text(extent = {{-500, -86}, {500, -146}}, textString = "%name", fontSize = 50)}, coordinateSystem(initialScale = 0.1)));
  end Valve;

  model Splitter
    annotation(
      Icon(coordinateSystem(initialScale = 0.1), graphics = {Polygon(origin = {-1, 1}, rotation = 180, lineColor = {0, 70, 70}, fillColor = {19, 224, 255}, lineThickness = 0.3, points = {{-100, 100}, {0, 100}, {100, 0}, {0, -100}, {-100, -100}, {-100, 100}}), Text(extent = {{-500, -120}, {500, -180}}, textString = "%name", fontSize = 50)}));
  end Splitter;

  model Compound_Separator
  equation

    annotation(
      Icon(coordinateSystem(extent = {{-100, -200}, {100, 200}}, initialScale = 0.1), graphics = {Line(origin = {-100, 0}, points = {{0, 120}, {0, -120}}, color = {0, 70, 70}, thickness = 0.3), Line(origin = {100, 0}, points = {{0, 120}, {0, -120}}, color = {0, 70, 70}, thickness = 0.3), Rectangle(origin = {0, 125}, lineColor = {0, 70, 70}, lineThickness = 0.3, extent = {{-120, 5}, {120, -5}}), Rectangle(origin = {0, -125}, lineColor = {0, 70, 70}, lineThickness = 0.3, extent = {{-120, 5}, {120, -5}}), Text(extent = {{-500, -220}, {500, -280}}, textString = "%name", fontSize = 50), Line(origin = {-100, 0}, points = {{0, 130}, {0, 150}}, color = {0, 70, 70}, thickness = 0.3), Line(origin = {100, 0}, points = {{0, 130}, {0, 150}}, color = {0, 70, 70}, thickness = 0.3), Line(origin = {-100, 0}, points = {{0, -130}, {0, -150}}, color = {0, 70, 70}, thickness = 0.3), Line(origin = {100, 0}, points = {{0, -130}, {0, -150}}, color = {0, 70, 70}, thickness = 0.3), Line(origin = {0, 150}, points = {{-100, 0}, {-85, 20}, {-40, 40}, {40, 40}, {85, 20}, {100, 0}}, color = {0, 70, 70}, thickness = 0.3, smooth = Smooth.Bezier), Line(origin = {0, -150}, rotation = 180, points = {{-100, 0}, {-85, 20}, {-40, 40}, {40, 40}, {85, 20}, {100, 0}}, color = {0, 70, 70}, thickness = 0.3, smooth = Smooth.Bezier)}),
      __OpenModelica_commandLineOptions = "");
  end Compound_Separator;

  model Centrifugal_Pump
  equation

    annotation(
      Icon(graphics = {Ellipse(origin = {0, 15}, lineColor = {0, 70, 70}, lineThickness = 0.3, extent = {{-85, 85}, {85, -85}}, endAngle = 360), Line(origin = {-66, -60}, points = {{0, 0}, {0, 0}}), Line(points = {{0, 100}, {100, 100}}, color = {0, 70, 70}, thickness = 0.3), Rectangle(lineColor = {0, 70, 70}, lineThickness = 0.3, extent = {{-90, -80}, {90, -100}}), Line(points = {{-100, 15}, {0, 15}}, color = {0, 70, 70}, thickness = 0.3), Text(extent = {{-500, -120}, {500, -180}}, textString = "%name", fontSize = 50)}, coordinateSystem(initialScale = 0.1)));
  end Centrifugal_Pump;

  model Adiabatic_Compressor
  equation

    annotation(
      Icon(graphics = {Polygon(lineColor = {0, 70, 70}, lineThickness = 0.3, points = {{-100, 80}, {100, 50}, {100, -50}, {-100, -80}, {-100, 80}}), Text(extent = {{-500, -100}, {500, -160}}, textString = "%name", fontSize = 50)}, coordinateSystem(initialScale = 0.1)));
  end Adiabatic_Compressor;

  model Adiabatic_Expander
    annotation(
      Icon(graphics = {Polygon(lineColor = {0, 70, 70}, lineThickness = 0.3, points = {{-100, 50}, {100, 80}, {100, -80}, {-100, -50}, {-100, 50}}), Text(extent = {{-500, -100}, {500, -160}}, textString = "%name", fontSize = 50)}, coordinateSystem(initialScale = 0.1)));
  end Adiabatic_Expander;

  model Flash
    annotation(
      Icon(coordinateSystem(extent = {{-100, -200}, {100, 200}}, initialScale = 0.1), graphics = {Line(origin = {-100, 0}, points = {{0, 120}, {0, -120}}, color = {0, 70, 70}, thickness = 0.3), Line(origin = {100, 0}, points = {{0, 120}, {0, -120}}, color = {0, 70, 70}, thickness = 0.3), Rectangle(origin = {0, 125}, lineColor = {0, 70, 70}, lineThickness = 0.3, extent = {{-120, 5}, {120, -5}}), Rectangle(origin = {0, -125}, lineColor = {0, 70, 70}, lineThickness = 0.3, extent = {{-120, 5}, {120, -5}}), Text(extent = {{-500, -220}, {500, -280}}, textString = "%name", fontSize = 50), Line(origin = {-100, 0}, points = {{0, 130}, {0, 150}}, color = {0, 70, 70}, thickness = 0.3), Line(origin = {100, 0}, points = {{0, 130}, {0, 150}}, color = {0, 70, 70}, thickness = 0.3), Line(origin = {-100, 0}, points = {{0, -130}, {0, -150}}, color = {0, 70, 70}, thickness = 0.3), Line(origin = {100, 0}, points = {{0, -130}, {0, -150}}, color = {0, 70, 70}, thickness = 0.3), Line(origin = {0, 150}, points = {{-100, 0}, {-85, 20}, {-40, 40}, {40, 40}, {85, 20}, {100, 0}}, color = {0, 70, 70}, thickness = 0.3, smooth = Smooth.Bezier), Line(origin = {0, -150}, rotation = 180, points = {{-100, 0}, {-85, 20}, {-40, 40}, {40, 40}, {85, 20}, {100, 0}}, color = {0, 70, 70}, thickness = 0.3, smooth = Smooth.Bezier), Line(points = {{-100, 0}, {-87.5, -20}, {-62.5, 20}, {-37.5, -20}, {-12.5, 20}, {12.5, -20}, {37.5, 20}, {62.5, -20}, {87.5, 20}, {100, 0}}, color = {0, 70, 70}, thickness = 0.3, smooth = Smooth.Bezier)}),
      __OpenModelica_commandLineOptions = "");
  end Flash;

  model Conversion_Reactor
  equation

    annotation(
      Icon(coordinateSystem(extent = {{-100, -200}, {100, 200}}, initialScale = 0.1), graphics = {Line(points = {{-100, 120}, {-100, -120}}, color = {0, 70, 70}, thickness = 0.3), Line(origin = {100, 0}, points = {{0, 120}, {0, -120}}, color = {0, 70, 70}, thickness = 0.3), Line(origin = {0, 150}, points = {{-100, 0}, {-85, 20}, {-40, 40}, {40, 40}, {85, 20}, {100, 0}}, color = {0, 70, 70}, thickness = 0.3, smooth = Smooth.Bezier), Rectangle(origin = {0, 125}, lineColor = {0, 70, 70}, lineThickness = 0.3, extent = {{-120, 5}, {120, -5}}), Rectangle(origin = {0, -125}, lineColor = {0, 70, 70}, lineThickness = 0.3, extent = {{-120, 5}, {120, -5}}), Text(extent = {{-500, -220}, {500, -280}}, textString = "%name", fontSize = 50), Line(origin = {0, 80}, points = {{-100, 0}, {100, 0}}, color = {0, 70, 70}, thickness = 0.3), Line(points = {{100, -80}, {33.3, 80}, {-33.3, -80}, {-100, 80}}, color = {0, 70, 70}, thickness = 0.3), Line(origin = {-2, 1.58}, points = {{-100, -80}, {-33.3, 80}, {33.3, -80}, {100, 80}}, color = {0, 70, 70}, thickness = 0.3), Line(origin = {-100, 0}, points = {{0, 130}, {0, 150}}, color = {0, 70, 70}, thickness = 0.3), Line(origin = {100, 0}, points = {{0, 130}, {0, 150}}, color = {0, 70, 70}, thickness = 0.3), Line(origin = {-100, 0}, points = {{0, -130}, {0, -150}}, color = {0, 70, 70}, thickness = 0.3), Line(origin = {100, 0}, points = {{0, -130}, {0, -150}}, color = {0, 70, 70}, thickness = 0.3), Line(origin = {0, -150}, rotation = 180, points = {{-100, 0}, {-85, 20}, {-40, 40}, {40, 40}, {85, 20}, {100, 0}}, color = {0, 70, 70}, thickness = 0.3, smooth = Smooth.Bezier), Line(origin = {0, -80}, points = {{-100, 0}, {100, 0}}, color = {0, 70, 70}, thickness = 0.3)}),
      __OpenModelica_commandLineOptions = "");
  end Conversion_Reactor;

  model PFR
  equation

    annotation(
      Icon(coordinateSystem(extent = {{-350, -100}, {350, 100}}, initialScale = 0.1), graphics = {Line(points = {{-320, 70}, {320, 70}}, color = {0, 70, 70}, thickness = 0.3), Line(points = {{-320, -70}, {320, -70}}, color = {0, 70, 70}, thickness = 0.3), Text(extent = {{-500, -90}, {500, -150}}, textString = "%name", fontSize = 50), Line(points = {{-250, 70}, {-250, -70}}, color = {0, 70, 70}, thickness = 0.3), Line(points = {{250, 70}, {250, -70}}, color = {0, 70, 70}, thickness = 0.3), Line(points = {{-320, 70}, {-350, 30}, {-350, -30}, {-320, -70}}, color = {0, 70, 70}, thickness = 0.3, smooth = Smooth.Bezier), Line(rotation = 180, points = {{-320, 70}, {-350, 30}, {-350, -30}, {-320, -70}}, color = {0, 70, 70}, thickness = 0.3, smooth = Smooth.Bezier), Line(points = {{-250, 70}, {-200, -70}, {-150, 70}, {-100, -70}, {-50, 70}, {0, -70}, {50, 70}, {100, -70}, {150, 70}, {200, -70}, {250, 70}}, color = {0, 70, 70}, thickness = 0.3), Line(rotation = 180, points = {{-250, 70}, {-200, -70}, {-150, 70}, {-100, -70}, {-50, 70}, {0, -70}, {50, 70}, {100, -70}, {150, 70}, {200, -70}, {250, 70}}, color = {0, 70, 70}, thickness = 0.3)}),
      Diagram(coordinateSystem(extent = {{-350, -100}, {350, 100}})),
      __OpenModelica_commandLineOptions = "");
  end PFR;

  model Distillation_Column
    annotation(
      Icon(coordinateSystem(extent = {{-250, -600}, {250, 600}}, initialScale = 0.1), graphics = {Line(points = {{-250, 400}, {-250, -400}}, color = {0, 70, 70}, thickness = 0.3), Line(points = {{-70, 400}, {-70, -400}}, color = {0, 70, 70}, thickness = 0.3), Line(points = {{-250, 400}, {-190, 440}, {-130, 440}, {-70, 400}}, color = {0, 70, 70}, thickness = 0.3, smooth = Smooth.Bezier), Ellipse(origin = {150, 505}, lineColor = {0, 70, 70}, lineThickness = 0.3, extent = {{-100, 100}, {100, -100}}, endAngle = 360), Ellipse(origin = {150, -503}, lineColor = {0, 70, 70}, lineThickness = 0.3, extent = {{-100, 100}, {100, -100}}, endAngle = 360), Line(points = {{50, 500}, {-160, 500}, {-160, 440}}, color = {0, 70, 70}, thickness = 0.3), Line(points = {{-70, 300}, {250, 300}}, color = {0, 70, 70}, thickness = 0.3), Line(points = {{150, 400}, {150, 300}}, color = {0, 70, 70}, thickness = 0.3), Line(points = {{50, -500}, {-160, -500}, {-160, -440}}, color = {0, 70, 70}, thickness = 0.3), Line(points = {{150, -300}, {150, -400}}, color = {0, 70, 70}, thickness = 0.3), Line(points = {{250, -300}, {-70, -300}}, color = {0, 70, 70}, thickness = 0.3), Line(points = {{50, -400}, {250, -600}}, color = {255, 0, 0}, thickness = 0.3), Line(points = {{50, 400}, {250, 600}}, color = {255, 0, 0}, thickness = 0.3), Line(points = {{230, 600}, {250, 600}, {250, 580}}, color = {255, 0, 0}, thickness = 0.3), Line(points = {{70, -400}, {50, -400}, {50, -420}}, color = {255, 0, 0}, thickness = 0.3), Line(points = {{-250, 250}, {-150, 250}}, color = {0, 70, 70}, thickness = 0.3), Line(points = {{-250, 83}, {-150, 83}}, color = {0, 70, 70}, thickness = 0.3), Line(points = {{-250, -84}, {-150, -84}}, color = {0, 70, 70}, thickness = 0.3), Line(points = {{-250, -250}, {-150, -250}}, color = {0, 70, 70}, thickness = 0.3), Line(points = {{-170, 167}, {-70, 167}}, color = {0, 70, 70}, thickness = 0.3), Line(points = {{-170, 0}, {-70, 0}}, color = {0, 70, 70}, thickness = 0.3), Line(points = {{-170, -167}, {-70, -167}}, color = {0, 70, 70}, thickness = 0.3), Text(extent = {{-500, -620}, {500, -680}}, textString = "%name", fontSize = 50), Line(points = {{-250, -400}, {-190, -440}, {-130, -440}, {-70, -400}}, color = {0, 70, 70}, thickness = 0.3, smooth = Smooth.Bezier)}),
      Diagram(coordinateSystem(extent = {{-250, -600}, {250, 600}})),
      __OpenModelica_commandLineOptions = "");
  end Distillation_Column;

  model Absorption_Column
  equation

    annotation(
      Icon(coordinateSystem(extent = {{-250, -450}, {250, 450}}, initialScale = 0.1), graphics = {Line(points = {{-90, 400}, {-90, -400}}, color = {0, 70, 70}, thickness = 0.3), Line(points = {{90, 400}, {90, -400}}, color = {0, 70, 70}, thickness = 0.3), Line(points = {{-90, 400}, {-30, 440}, {30, 440}, {90, 400}}, color = {0, 70, 70}, thickness = 0.3, smooth = Smooth.Bezier), Line(rotation = 180, points = {{-90, 400}, {-30, 440}, {30, 440}, {90, 400}}, color = {0, 70, 70}, thickness = 0.3, smooth = Smooth.Bezier), Line(points = {{-90, 250}, {10, 250}}, color = {0, 70, 70}, thickness = 0.3), Line(points = {{-10, 167}, {90, 167}}, color = {0, 70, 70}, thickness = 0.3), Line(points = {{-90, 83}, {10, 83}}, color = {0, 70, 70}, thickness = 0.3), Line(points = {{-10, 0}, {90, 0}}, color = {0, 70, 70}, thickness = 0.3), Line(points = {{-90, -84}, {10, -84}}, color = {0, 70, 70}, thickness = 0.3), Line(points = {{-10, -167}, {90, -167}}, color = {0, 70, 70}, thickness = 0.3), Line(points = {{-90, -250}, {10, -250}}, color = {0, 70, 70}, thickness = 0.3), Line(points = {{-250, 300}, {-90, 300}}, color = {0, 70, 70}, thickness = 0.3), Line(rotation = 180, points = {{-250, 300}, {-90, 300}}, color = {0, 70, 70}, thickness = 0.3), Line(points = {{90, 300}, {250, 300}}, color = {0, 70, 70}, thickness = 0.3), Line(points = {{-250, -300}, {-90, -300}}, color = {0, 70, 70}, thickness = 0.3), Text(extent = {{-500, -460}, {500, -520}}, textString = "%name", fontSize = 50)}),
      Diagram(coordinateSystem(extent = {{-250, -450}, {250, 450}})),
      __OpenModelica_commandLineOptions = "");
  end Absorption_Column;

  model Material_Stream
    annotation(
      Icon(coordinateSystem(initialScale = 0.1), graphics = {Line(points = {{-100, 0}, {100, 0}}, color = {0, 70, 70}, thickness = 0.3), Line(points = {{80, 20}, {100, 0}, {80, -20}}, color = {0, 70, 70}, thickness = 0.3), Text(extent = {{-500, -40}, {500, -100}}, textString = "%name", fontSize = 50)}));
  end Material_Stream;

  model Energy_Stream
    annotation(
      Icon(coordinateSystem(initialScale = 0.1), graphics = {Line(points = {{-100, 0}, {100, 0}}, color = {255, 0, 0}, thickness = 0.3), Line(points = {{80, 20}, {100, 0}, {80, -20}}, color = {255, 0, 0}, thickness = 0.3), Text(extent = {{-500, -40}, {500, -100}}, textString = "%name", fontSize = 50)}));
  end Energy_Stream;
end Icons;
