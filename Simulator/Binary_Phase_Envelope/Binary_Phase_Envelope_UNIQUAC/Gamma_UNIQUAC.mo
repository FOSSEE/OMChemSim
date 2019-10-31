within Simulator.Binary_Phase_Envelope.Binary_Phase_Envelope_UNIQUAC;

function Gamma_UNIQUAC
  input Integer Choice "Enter if choice of VLE curve is Pxy or Txy";
  //Note : Choice = 1 = P-x-y-Envelope
  //       Choice = 2 = T-x-y-Envelope
  input Integer N "Number of data points", NOC "Total number of components";
  input Real z1[N + 1], z2[N + 1];
  input Real R[NOC], Q[NOC];
  input Real tow[NOC, NOC];
  input Real towk[N + 1, NOC, NOC];
  parameter Real Z = 10 "Compresseblity Factor";
  parameter Real R_gas = 1.98721 "Gas Constant";
  //Activity coefficients
  output Real gammaBubl1[N + 1], gammaBubl2[N + 1];
protected
  //Intermediate parameters used to calculate the Combinatorial and Residual contribution"
  Real r_bubl[N + 1], q_bubl[N + 1];
  Real teta1_bubl[N + 1], teta2_bubl[N + 1];
  Real S1_bubl[N + 1], S2_bubl[N + 1];
  Real sum1_bubl[N + 1], sum2_bubl[N + 1];
  //Residual contribution term of Activity coefficient
  Real gammar1_bubl[N + 1], gammar2_bubl[N + 1];
  //Cobinatorial contribution term of Activity coefficient
  Real gammac1_bubl[N + 1], gammac2_bubl[N + 1];
  //Empherical Parameter at different temperatures
  Real toww[N, NOC, NOC];
  //=========================================================================================
algorithm
  for i in 1:N + 1 loop
    r_bubl[i] := z1[i] * R[1] + z2[i] * R[2];
    q_bubl[i] := z1[i] * Q[1] + z2[i] * Q[2];
  end for;
  if Choice == 1 then
    for i in 1:N + 1 loop
      teta1_bubl[i] := z1[i] * Q[1] * (1 / q_bubl[i]);
      teta2_bubl[i] := z2[i] * Q[2] * (1 / q_bubl[i]);
      S1_bubl[i] := teta1_bubl[i] * tow[1, 1] + teta2_bubl[i] * tow[1, 2];
      S2_bubl[i] := teta1_bubl[i] * tow[2, 1] + teta2_bubl[i] * tow[2, 2];
      sum1_bubl[i] := teta1_bubl[i] * (tow[1, 1] / S1_bubl[i]) + teta2_bubl[i] * (tow[1, 2] / S2_bubl[i]);
      sum2_bubl[i] := teta1_bubl[i] * (tow[2, 1] / S1_bubl[i]) + teta2_bubl[i] * (tow[2, 2] / S2_bubl[i]);
      gammar1_bubl[i] := exp(Q[1] * (1 - log(S1_bubl[i]) - sum1_bubl[i]));
      gammar2_bubl[i] := exp(Q[2] * (1 - log(S2_bubl[i]) - sum2_bubl[i]));
      gammac1_bubl[i] := exp(1 - R[1] / r_bubl[i] + log(R[1] / r_bubl[i]) + (-Z / 2 * Q[1] * (1 - R[1] / r_bubl[i] / (Q[1] / q_bubl[i]) + log(R[1] / r_bubl[i] / (Q[1] / q_bubl[i])))));
      gammac2_bubl[i] := exp(1 - R[2] / r_bubl[i] + log(R[2] / r_bubl[i]) + (-Z / 2 * Q[2] * (1 - R[2] / r_bubl[i] / (Q[2] / q_bubl[i]) + log(R[2] / r_bubl[i] / (Q[2] / q_bubl[i])))));
      gammaBubl1[i] := exp(log(gammac1_bubl[i]) + log(gammar1_bubl[i]));
      gammaBubl2[i] := exp(log(gammac2_bubl[i]) + log(gammar2_bubl[i]));
    end for;
  else
    for i in 1:N + 1 loop
      teta1_bubl[i] := z1[i] * Q[1] * (1 / q_bubl[i]);
      teta2_bubl[i] := z2[i] * Q[2] * (1 / q_bubl[i]);
      S1_bubl[i] := teta1_bubl[i] * towk[i, 1, 1] + teta2_bubl[i] * towk[i, 1, 2];
      S2_bubl[i] := teta1_bubl[i] * towk[i, 2, 1] + teta2_bubl[i] * towk[i, 2, 2];
      sum1_bubl[i] := teta1_bubl[i] * (towk[i, 1, 1] / S1_bubl[i]) + teta2_bubl[i] * (towk[i, 1, 2] / S2_bubl[i]);
      sum2_bubl[i] := teta1_bubl[i] * (towk[i, 2, 1] / S1_bubl[i]) + teta2_bubl[i] * (towk[i, 2, 2] / S2_bubl[i]);
      gammar1_bubl[i] := exp(Q[1] * (1 - log(S1_bubl[i]) - sum1_bubl[i]));
      gammar2_bubl[i] := exp(Q[2] * (1 - log(S2_bubl[i]) - sum2_bubl[i]));
      gammac1_bubl[i] := exp(1 - R[1] / r_bubl[i] + log(R[1] / r_bubl[i]) + (-Z / 2 * Q[1] * (1 - R[1] / r_bubl[i] / (Q[1] / q_bubl[i]) + log(R[1] / r_bubl[i] / (Q[1] / q_bubl[i])))));
      gammac2_bubl[i] := exp(1 - R[2] / r_bubl[i] + log(R[2] / r_bubl[i]) + (-Z / 2 * Q[2] * (1 - R[2] / r_bubl[i] / (Q[2] / q_bubl[i]) + log(R[2] / r_bubl[i] / (Q[2] / q_bubl[i])))));
      gammaBubl1[i] := exp(log(gammac1_bubl[i]) + log(gammar1_bubl[i]));
      gammaBubl2[i] := exp(log(gammac2_bubl[i]) + log(gammar2_bubl[i]));
    end for;
  end if;
//Calculation of Activity coefficients at different pressures( P-x-y calculation routine)
//Calculation of residual contribution term of activity coefficient
//Calculation of combinatorial term of activity coefficient
//Calculation of activity coefficients at different temperatures (T-x-y calculation routine)
//Calculation of residual contribution term of activity coefficient
//Calculation of combinatorial term of activity coefficient
end Gamma_UNIQUAC;
