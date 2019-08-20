within Simulator.Files;

package Connection
  connector matConn
    Real P(min = 0, start = 101325), T(min = 0, start = 273.15), mixMolFlo(min = 0, start = 100), mixMolEnth, mixMolEntr, mixMolFrac[3, connNOC](each min = 0, each max = 1, each start = 1/(connNOC + 1)), vapPhasMolFrac(min = 0, max = 1, start = 0.5);
    parameter Integer connNOC(start = 2);
    annotation(
      Icon(coordinateSystem(initialScale = 0.1), graphics = {Rectangle(lineColor = {0, 70, 70}, fillColor = {0, 70, 70},fillPattern = FillPattern.Solid, lineThickness = 0.3, extent = {{-50, 50}, {50, -50}})}));
  end matConn;

  connector enConn
    Real enFlo;
    annotation(
      Icon(coordinateSystem(initialScale = 0.1), graphics = {Rectangle(lineColor = {255, 0, 0},fillColor = {255, 0, 0}, fillPattern = FillPattern.Solid, extent = {{-50, 50}, {50, -50}})}));
  end enConn;

  connector trayConn
    Real mixMolFlo(min = 0, start = 100), mixMolEnth, mixMolFrac[connNOC](each min = 0, each max = 1, each start = 1/(connNOC + 1));
    parameter Integer connNOC;
    annotation(
      Icon(coordinateSystem(initialScale = 0.1), graphics = {Rectangle(fillColor = {8, 184, 211}, fillPattern = FillPattern.Solid, extent = {{-50, 50}, {50, -50}})}));
  end trayConn;

end Connection;
