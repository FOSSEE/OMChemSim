within Simulator.BinaryPhaseEnvelope;

package BinaryPhaseEnvelopeUNIFAC
    extends Modelica.Icons.ExamplesPackage;
  model PxyUNIFAC
    extends Modelica.Icons.Example;
  //Libraries
    import Simulator.*;
    //Extension of Chemsep Database
    Simulator.Files.ChemsepDatabase data;
    //Parameter Section
    //Selection of compounds
    parameter data.Methylethylketone meth;
    parameter data.Aceticacid eth;
    //Instantiation of selected compounds
    parameter Simulator.Files.ChemsepDatabase.GeneralProperties comp[NOC] = {meth, eth};
    parameter Integer NOC = 2 "Number of components";
    parameter Integer Choice = 1 "System choice of Txy or Pxy";
    parameter Real T(unit = "K") = 375 "System Temperature";
    parameter Integer N = 40 "Number of points of data generation";
    parameter Integer m = 4 "Interaction parameter index";
    parameter Integer k = 4 "Number of Functional groups present in the compound";
    parameter Real a[m, k] = {{0, 0, 476.4, 663.5}, {0, 0, 476.4, 663.5}, {26.76, 26.76, 0, 669.4}, {315.3, 315.3, -297.8, 0}} "Binary  intraction parameter";
    parameter Real V[NOC, k] = {{1, 1, 1, 0}, {1, 0, 0, 1}} "Number of group of kind k in molecule ";
    parameter Real R[NOC, k] = {{0.9011, 0.6744, 1.6724, 0.0}, {0.9011, 0, 0, 1.3013}} "Group volume of group k ";
    parameter Real Q[NOC, k] = {{0.848, 0.540, 1.448, 0}, {0.848, 0, 0, 1.224}} "Group surface area of group k";
    //Gas constant
    parameter Real R_gas = 1.98721;
    //Variable Section
    Real delta "Increment step";
    Real e[k, NOC];
    Real B[NOC, k];
    Real q[NOC] "Van der waal molecular surface area";
    Real r[NOC] "Van der waal molecular volume";
    Real tow[m, k] "Empherical Parameter (tow) at the system temperature";
    //Mole Fractions (x-axis) of the P-x-y plot
    Real z1[N + 1], z2[N + 1];
    //Intermediate parameters used to calculate the Combinatorial contribution"
    Real J1_bubl[N + 1], J2_bubl[N + 1];
    Real L1_bubl[N + 1], L2_bubl[N + 1];
    Real gammac1_bubl[N + 1], gammac2_bubl[N + 1];
    //Intermediate parameters used to calculate the Residual contribution"
    Real teta1_bubl[N + 1, k];
    Real S1_bubl[N + 1, k];
    Real sum1_bubl[N + 1, k], sum2_bubl[N + 1, k];
    Real sum_bubl[N + 1], summ_bubl[N + 1];
    Real gammar1_bubl[N + 1], gammar2_bubl[N + 1];
    //Activity coefficients at different Pressures
    Real gammaBubl1[N + 1](each start = 0.5), gammaBubl2[N + 1];
    //Bubble Pressure
    Real P[N + 1](each unit = "Pa", each start = 117018);
    //Distribution coefficient
    Real K1[N + 1];
    //Vapour Phase Mole Fraction
    Real y1[N + 1](each start = 0.5), y2[N + 1](each start = 0.5);
    //Vapour Pressure at the chosen temperature
    Real Psat[NOC](each unit = "Pa") "Vapour Pressure";
    //===========================================================================================
    //Equation Section
  equation
//Calculation of Vapour Pressure at the input temperature
//Thermodynamic Function Psat is instantiated from Simulator Package
    for i in 1:NOC loop
      Psat[i] = Simulator.Files.ThermodynamicFunctions.Psat(comp[i].VP, T);
    end for;
//Calculation of increment step for the total number of points
    delta = 1 / N;
//Calculation of Unifac parameter R and Q for the induvidual compounds
    for i in 1:NOC loop
      for j in 1:k loop
        B[i, j] = sum(e[:, i] .* tow[:, j]);
      end for;
    end for;
    for i in 1:NOC loop
      r[i] = sum(V[i, :] .* R[i, :]);
      q[i] = sum(V[i, :] .* Q[i, :]);
      e[:, i] = V[i, :] .* Q[i, :] / q[i];
    end for;
//Calculation of Empherical parameter (tow) at the system temperature
    for i in 1:m loop
      tow[i, :] = exp((-a[i, :]) / T);
    end for;
//Generation of mole fraction from 0 to 1 in steps of "delta"
    z1[1] = 0;
    for i in 2:N + 1 loop
      z1[i] = z1[i - 1] + delta;
    end for;
    for i in 1:N + 1 loop
      z2[i] = 1 - z1[i];
    end for;
//Calculation of combinatorial contribution parameter used to compute activity coefficient at the corresponding compositions
    for i in 1:N + 1 loop
      J1_bubl[i] = r[1] / (r[1] * z1[i] + r[2] * z2[i]);
      J2_bubl[i] = r[2] / (r[1] * z1[i] + r[2] * z2[i]);
      L1_bubl[i] = q[1] / (q[1] * z1[i] + q[2] * z2[i]);
      L2_bubl[i] = q[2] / (q[1] * z1[i] + q[2] * z2[i]);
      gammac1_bubl[i] = exp(1 - J1_bubl[i] + log(J1_bubl[i]) + (-5 * q[1] * (1 - J1_bubl[i] / L1_bubl[i] + log(J1_bubl[i] / L1_bubl[i]))));
      gammac2_bubl[i] = exp(1 - J2_bubl[i] + log(J2_bubl[i]) + (-5 * q[2] * (1 - J2_bubl[i] / L2_bubl[i] + log(J2_bubl[i] / L2_bubl[i]))));
    end for;
//Calculation of residual contribution parameter used to compute activity coefficient at the corresponding compositions
    for i in 1:N + 1 loop
      teta1_bubl[i, :] = (z1[i] * q[1] .* e[:, 1] + z2[i] * q[2] .* e[:, 2]) / (z1[i] * q[1] + z2[i] * q[2]);
    end for;
    for i in 1:N + 1 loop
      for j in 1:k loop
        S1_bubl[i, j] = sum(teta1_bubl[i, :] .* tow[:, j]);
        sum1_bubl[i, j] = teta1_bubl[i, j] * B[1, j] / S1_bubl[i, j] - e[j, 1] * log(B[1, j] / S1_bubl[i, j]);
        sum2_bubl[i, j] = teta1_bubl[i, j] * B[2, j] / S1_bubl[i, j] - e[j, 2] * log(B[2, j] / S1_bubl[i, j]);
      end for;
    end for;
    for i in 1:N + 1 loop
      gammar1_bubl[i] = exp(q[1] * (1 - sum_bubl[i]));
      gammar2_bubl[i] = exp(q[2] * (1 - summ_bubl[i]));
      sum_bubl[i] = sum(sum1_bubl[i, :]);
      summ_bubl[i] = sum(sum2_bubl[i, :]);
      gammaBubl1[i] = exp(log(gammac1_bubl[i]) + log(gammar1_bubl[i]));
      gammaBubl2[i] = exp(log(gammac2_bubl[i]) + log(gammar2_bubl[i]));
    end for;
//Bubble point calculation
    for i in 1:N + 1 loop
      P[i] = gammaBubl1[i] * z1[i] * exp(comp[1].VP[2] + comp[1].VP[3] / T + comp[1].VP[4] * log(T) + comp[1].VP[5] * T ^ comp[1].VP[6]) + gammaBubl2[i] * z2[i] * exp(comp[2].VP[2] + comp[2].VP[3] / T + comp[2].VP[4] * log(T) + comp[2].VP[5] * T ^ comp[2].VP[6]);
    end for;
//Phase Equilibria
    for i in 1:N + 1 loop
      K1[i] = gammaBubl1[i] * (Psat[1] / P[i]);
      y1[i] = K1[i] * z1[i];
      y2[i] = 1 - y1[i];
    end for;
  end PxyUNIFAC;

  //====================================================================================================

  model TxyUNIFAC
    extends Modelica.Icons.Example;
    //Libraries
    import Simulator.*;
    //Extension of Chemsep Database
    Simulator.Files.ChemsepDatabase data;
    //Parameter Section
    //Selection of compounds
    parameter data.Methylethylketone meth;
    parameter data.Aceticacid eth;
    //Instantiation of selected compounds
    parameter Simulator.Files.ChemsepDatabase.GeneralProperties comp[NOC] = {meth, eth};
    parameter Real Z = 10 "Compressiblity Factor";
    parameter Integer Choice = 2 "System choice of Txy or Pxy";
    parameter Integer NOC = 2 "Number of components";
    parameter Real P(unit = "Pa") = 101325 "System Pressure";
    parameter Integer N = 40 "Number of points of data generation";
    parameter Integer m = 4 "Interaction parameter index", k = 4 "Number of Functional groups present in the compound";
    parameter Real a[m, k] = {{0, 0, 476.4, 663.5}, {0, 0, 476.4, 663.5}, {26.76, 26.76, 0, 669.4}, {315.3, 315.3, -297.8, 0}} "Binary  intraction parameter";
    parameter Real V[NOC, k] = {{1, 1, 1, 0}, {1, 0, 0, 1}} "number of group of kind k in molecule ";
    parameter Real R[NOC, k] = {{0.9011, 0.6744, 1.6724, 0.0}, {0.9011, 0, 0, 1.3013}} "group volume of group k ";
    parameter Real Q[NOC, k] = {{0.848, 0.540, 1.448, 0}, {0.848, 0, 0, 1.224}} "group surface area of group k";
    //Gas constant
    parameter Real R_gas = 1.98721;
    //Variable Section
    Real delta "Increment step";
    Real e[k, NOC];
    Real B[N + 1, NOC, k];
    Real q[NOC] "van der walls molecular surface area";
    Real r[NOC] "van der walls molecular volume";
    //Empherical parameter (tow) at different temperatures
    Real tow[N + 1, m, k];
    //Intermediate parameters used to calculate the Combinatorial contribution"
    Real J1_bubl[N + 1], J2_bubl[N + 1];
    Real L1_bubl[N + 1], L2_bubl[N + 1];
    Real gammac1_bubl[N + 1], gammac2_bubl[N + 1];
    //Intermediate parameters used to calculate the Residual contribution"
    Real teta1_bubl[N + 1, k];
    Real S1_bubl[N + 1, k];
    Real sum1_bubl[N + 1, k], sum2_bubl[N + 1, k];
    Real sum_bubl[N + 1], summ_bubl[N + 1];
    Real gammar1_bubl[N + 1], gammar2_bubl[N + 1];
    //Activity coefficients at different Temperatures
    Real gammaBubl1[N + 1](each start = 0.5), gammaBubl2[N + 1];
    //Mole Fractions (x-axis) of the T-x-y plot
    Real z1[N + 1], z2[N + 1];
    //Bubble Temperature
    Real T[N + 1](unit = "K", each start = 300);
    //Distribution coefficient
    Real K1[N + 1];
    //Vapour Phase Mole Fraction
    Real y1[N + 1](each start = 0.5), y2[N + 1](each start = 0.5);
    //Vapour Pressure at the chosen temperature range
    Real Psat[N + 1, 1];
    //======================================================================================================
  equation
//Calculation of increment step for the total number of points
    delta = 1 / N;
//Calculation of vapour pressures at different temperatures
    for i in 1:N + 1 loop
      Psat[i, 1] = Simulator.Files.ThermodynamicFunctions.Psat(comp[1].VP, T[i]);
    end for;
//Generation of mole fraction from 0 to 1 in steps of "delta"
    z1[1] = 0;
    for i in 2:N + 1 loop
      z1[i] = z1[i - 1] + delta;
    end for;
    for i in 1:N + 1 loop
      z2[i] = 1 - z1[i];
    end for;
//Calculation of r and q for compounds
    for l in 1:N + 1 loop
      for i in 1:NOC loop
        for j in 1:k loop
          B[l, i, j] = sum(e[:, i] .* tow[l, :, j]);
        end for;
      end for;
    end for;
    for i in 1:NOC loop
      r[i] = sum(V[i, :] .* R[i, :]);
      q[i] = sum(V[i, :] .* Q[i, :]);
      e[:, i] = V[i, :] .* Q[i, :] / q[i];
    end for;
//Empherical parameter (towk) is calculated at different temperatures in the T-x-y mode of operation
    for j in 1:N + 1 loop
      for i in 1:m loop
        tow[j, i, :] = exp((-a[i, :]) / T[j]);
      end for;
    end for;
//Calculation of combinatorial contribution parameter used to compute activity coefficient at the corresponding compositions
    for i in 1:N + 1 loop
      J1_bubl[i] = r[1] / (r[1] * z1[i] + r[2] * z2[i]);
      J2_bubl[i] = r[2] / (r[1] * z1[i] + r[2] * z2[i]);
      L1_bubl[i] = q[1] / (q[1] * z1[i] + q[2] * z2[i]);
      L2_bubl[i] = q[2] / (q[1] * z1[i] + q[2] * z2[i]);
      gammac1_bubl[i] = exp(1 - J1_bubl[i] + log(J1_bubl[i]) + (-5 * q[1] * (1 - J1_bubl[i] / L1_bubl[i] + log(J1_bubl[i] / L1_bubl[i]))));
      gammac2_bubl[i] = exp(1 - J2_bubl[i] + log(J2_bubl[i]) + (-5 * q[2] * (1 - J2_bubl[i] / L2_bubl[i] + log(J2_bubl[i] / L2_bubl[i]))));
    end for;
//Calculation of residual contribution parameter used to compute activity coefficient at the corresponding compositions
    for i in 1:N + 1 loop
      teta1_bubl[i, :] = (z1[i] * q[1] .* e[:, 1] + z2[i] * q[2] .* e[:, 2]) / (z1[i] * q[1] + z2[i] * q[2]);
    end for;
    for i in 1:N + 1 loop
      for j in 1:k loop
        S1_bubl[i, j] = sum(teta1_bubl[i, :] .* tow[i, :, j]);
      end for;
    end for;
    for i in 1:N + 1 loop
      for j in 1:k loop
        sum1_bubl[i, j] = teta1_bubl[i, j] * B[i, 1, j] / S1_bubl[i, j] - e[j, 1] * log(B[i, 1, j] / S1_bubl[i, j]);
        sum2_bubl[i, j] = teta1_bubl[i, j] * B[i, 2, j] / S1_bubl[i, j] - e[j, 2] * log(B[i, 2, j] / S1_bubl[i, j]);
      end for;
    end for;
    for i in 1:N + 1 loop
      gammar1_bubl[i] = exp(q[1] * (1 - sum_bubl[i]));
      gammar2_bubl[i] = exp(q[2] * (1 - summ_bubl[i]));
      sum_bubl[i] = sum(sum1_bubl[i, :]);
      summ_bubl[i] = sum(sum2_bubl[i, :]);
      gammaBubl1[i] = exp(log(gammac1_bubl[i]) + log(gammar1_bubl[i]));
      gammaBubl2[i] = exp(log(gammac2_bubl[i]) + log(gammar2_bubl[i]));
    end for;
//Bubble point calculation
    for i in 1:N + 1 loop
      P = gammaBubl1[i] * z1[i] * exp(comp[1].VP[2] + comp[1].VP[3] / T[i] + comp[1].VP[4] * log(T[i]) + comp[1].VP[5] * T[i] ^ comp[1].VP[6]) + gammaBubl2[i] * z2[i] * exp(comp[2].VP[2] + comp[2].VP[3] / T[i] + comp[2].VP[4] * log(T[i]) + comp[2].VP[5] * T[i] ^ comp[2].VP[6]);
    end for;
//Phase Equlibria
    for i in 1:N + 1 loop
      K1[i] = gammaBubl1[i] * (Psat[i, 1] / P);
      y1[i] = K1[i] * z1[i];
      y2[i] = 1 - y1[i];
    end for;
  end TxyUNIFAC;

  //================================================================================================================
end BinaryPhaseEnvelopeUNIFAC;
