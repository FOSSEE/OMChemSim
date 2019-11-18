within Simulator.Streams;

model EnergyStream
  extends Simulator.Files.Icons.Energy_Stream;
  Real Q;
  Simulator.Files.Connection.enConn In annotation(
    Placement(visible = true, transformation(origin = {-100, -2}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Files.Connection.enConn Out annotation(
    Placement(visible = true, transformation(origin = {100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
equation
//connector equation
  Q = In.Q;
  Q = Out.Q;
end EnergyStream;
