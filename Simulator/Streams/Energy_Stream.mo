within Simulator.Streams;

model Energy_Stream
  Real enFlo;
  Files.Connection.enConn inlet annotation(
    Placement(visible = true, transformation(origin = {-100, -2}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-100, -2}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Files.Connection.enConn outlet annotation(
    Placement(visible = true, transformation(origin = {100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
equation
//connector equation
  enFlo = inlet.enFlo;
  enFlo = outlet.enFlo;
end Energy_Stream;
