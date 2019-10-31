within Simulator.Binary_Phase_Envelope.Binary_Phase_Envelope_PR;

function Compresseblity_Factor
  input Real b[NOC];
  input Real aij[NOC, NOC];
  input Real P;
  input Real T;
  input Integer NOC;
  input Real m[NOC];
  output Real am;
  output Real bm;
  output Real A;
  output Real B;
  output Real Z[3];
protected
  Real R = 8.314;
  Real C[4];
  Real ZR[3, 2];
algorithm
  am := sum({{m[i] * m[j] * aij[i, j] for i in 1:NOC} for j in 1:NOC});
  bm := sum(b .* m);
  A := am * P / (R * T) ^ 2;
  B := bm * P / (R * T);
  C[1] := 1;
  C[2] := B - 1;
  C[3] := A - 3 * B ^ 2 - 2 * B;
  C[4] := B ^ 3 + B ^ 2 - A * B;
  ZR := Modelica.Math.Vectors.Utilities.roots(C);
  Z := {ZR[i, 1] for i in 1:3};
end Compresseblity_Factor;
