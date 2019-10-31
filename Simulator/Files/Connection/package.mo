within Simulator.Files;

package Connection
  connector matConn
    Real P, T, mixMolFlo, mixMolEnth, mixMolEntr, mixMolFrac[3, connNOC], vapPhasMolFrac;
    parameter Integer connNOC;
    annotation(
      Icon(coordinateSystem(initialScale = 0.1), graphics = {Rectangle(lineColor = {0, 70, 70}, fillColor = {0, 70, 70}, fillPattern = FillPattern.Solid, lineThickness = 0.3, extent = {{-50, 50}, {50, -50}})}));
  end matConn;

  connector enConn
    Real enFlo;
    annotation(
      Icon(coordinateSystem(initialScale = 0.1), graphics = {Rectangle(lineColor = {255, 0, 0}, fillColor = {255, 0, 0}, fillPattern = FillPattern.Solid, extent = {{-50, 50}, {50, -50}})}));
  end enConn;

  connector trayConn
    Real mixMolFlo, mixMolEnth, mixMolFrac[connNOC];
    parameter Integer connNOC;
    annotation(
      Icon(coordinateSystem(initialScale = 0.1), graphics = {Rectangle(fillColor = {8, 184, 211}, fillPattern = FillPattern.Solid, extent = {{-50, 50}, {50, -50}})}));
  end trayConn;
end Connection;
