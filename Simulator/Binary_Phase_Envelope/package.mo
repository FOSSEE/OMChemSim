within Simulator;

package Binary_Phase_Envelope
  package Binary_Phase_Envelope_UNIQUAC
    //==============================================================================================================

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

    //================================================================================================
    //Binary Phase Envelope
    //Envelope Type : P-x-y
    //Thermodynamic-Model : UNIQUAC
    //Nature of System    : Azeotropic System
    //========================================================================================

    model P_x_y_UNIQUAC
      //Libraries
      import Simulator.*;
      //Extension of Chemsep Database
      Simulator.Files.Chemsep_Database data;
      //Parameter Section
      //Selection of compounds
      parameter data.Water wat;
      parameter data.Ethanol eth;
      //Instantiation of selected compounds
      parameter Simulator.Files.Chemsep_Database.General_Properties comp[NOC] = {wat, eth};
      parameter Integer NOC = 2 "Number of components";
      parameter Integer Choice = 1 "System choice of Txy or Pxy";
      parameter Real T(unit = "K") = 315 "System Temperature";
      //Empherical parameter (towk) at different temperatures
      //Note : The below value will be active only in the T-x-y phase envelope routine
      Real towk[N + 1, NOC, NOC];
      parameter Integer N = 40 "Number of points of data generation";
      Real delta "Increment step";
      parameter Real a[NOC, NOC] = Simulator.Files.Thermodynamic_Functions.BIP_UNIQUAC(NOC, comp.name) "Interaction Parameters";
      //UNIQUAC parameters instantiated from Chemsep Database
      parameter Real R[NOC] = comp.UniquacR;
      parameter Real Q[NOC] = comp.UniquacQ;
      //Variable Section
      //Empherical Parameter (tow) at the system temperature
      Real tow[NOC, NOC];
      //Mole Fractions (x-axis) of the P-x-y plot
      Real z1[N + 1], z2[N + 1];
      //Activity coefficients at different Pressures
      Real gammaBubl1[N + 1], gammaBubl2[N + 1];
      //Bubble Pressure
      Real P[N + 1](each unit = "Pa", each start = 776454);
      //Distribution coefficient
      Real K1[N + 1];
      //Vapour Phase Mole Fraction
      Real y1[N + 1](each start = 0.5), y2[N + 1](each start = 0.5);
      //Vapour Pressure at the chosen temperature
      Real Psat[NOC](unit = "Pa") "Vapour Pressure";
      //=========================================================================================
      //Equation Section
    equation
//Calculation of Vapour Pressure at the input temperature
//Thermodynamic Function Psat is instantiated from Simulator Package
      for i in 1:NOC loop
        Psat[i] = Simulator.Files.Thermodynamic_Functions.Psat(comp[i].VP, T);
      end for;
//Calculation of increment step for the total number of points
      delta = 1 / N;
//Empherical parameter (towk) is assigned to 1 for P-x-y mode of operation
      for k in 1:N + 1 loop
        for i in 1:NOC loop
          for j in 1:NOC loop
            towk[k, i, j] = 1;
          end for;
        end for;
      end for;
//Calculation of Empherical parameter (tow) at the system temperature
      tow = Simulator.Files.Thermodynamic_Functions.Tow_UNIQUAC(NOC, a, T);
//Generation of mole fraction from 0 to 1 in steps of "delta"
      z1[1] = 0;
      for i in 2:N + 1 loop
        z1[i] = z1[i - 1] + delta;
      end for;
      for i in 1:N + 1 loop
        z2[i] = 1 - z1[i];
      end for;
//Calculation of Activity coefficients at different conditions using the function "Gamma_UNIQUAC"
      (gammaBubl1, gammaBubl2) = Binary_Phase_Envelope_UNIQUAC.Gamma_UNIQUAC(Choice, N, NOC, z1, z2, R, Q, tow, towk);
//Bubble point calculation
      for i in 1:N + 1 loop
        P[i] = gammaBubl1[i] * z1[i] * exp(comp[1].VP[2] + comp[1].VP[3] / T + comp[1].VP[4] * log(T) + comp[1].VP[5] * T ^ comp[1].VP[6]) + gammaBubl2[i] * z2[i] * exp(comp[2].VP[2] + comp[2].VP[3] / T + comp[2].VP[4] * log(T) + comp[2].VP[5] * T ^ comp[2].VP[6]);
      end for;
//Phase Equlibria
      for i in 1:N + 1 loop
        K1[i] = gammaBubl1[i] * (Psat[1] / P[i]);
        y1[i] = K1[i] * z1[i];
        y2[i] = 1 - y1[i];
      end for;
    end P_x_y_UNIQUAC;

    //=====================================================================================================

    model T_x_y_UNIQUAC
      //Libraries
      import Simulator.*;
      //Extension of Chemsep database
      Simulator.Files.Chemsep_Database data;
      //Parameter Section
      //Selection of compounds
      parameter data.Water wat;
      parameter data.Ethanol eth;
      //Instantiation of selected compounds
      parameter Simulator.Files.Chemsep_Database.General_Properties comp[NOC] = {wat, eth};
      parameter Integer Choice = 2 "System choice of Txy or Pxy";
      parameter Integer NOC = 2 "Number of components";
      parameter Real P(unit = "Pa") = 101325 "System Pressure";
      parameter Integer N = 40 "Number of points of data generation";
      //UNIQUAC Parameters
      parameter Real R[NOC] = comp.UniquacR;
      parameter Real Q[NOC] = comp.UniquacQ;
      parameter Real a[NOC, NOC] = Simulator.Files.Thermodynamic_Functions.BIP_UNIQUAC(NOC, comp.name) "Interaction temperatures";
      //Variable Section
      Real delta "Increment step";
      //Empherical parameter (towk) at different temperatures
      //Note : The below value will be active only in the T-x-y phase envelope routine
      Real towk[N + 1, NOC, NOC];
      //Empherical Parameter (tow) at the system temperature
      //Note : The below value will be active only in the P-x-y phase envelope routine
      Real tow[NOC, NOC];
      //Mole Fractions (x-axis) of the T-x-y plot
      Real z1[N + 1], z2[N + 1];
      //Bubble Temperature
      Real T[N + 1](each unit = "K", each start = 300);
      //Distribution coefficient
      Real K1[N + 1];
      //Vapour Phase Mole Fraction
      Real y1[N + 1](each start = 0.5), y2[N + 1](each start = 0.5);
      //Vapour Pressure at the chosen temperature range
      Real Psat[N + 1, 1](each unit = "Pa");
      //Activity coefficients at different Temperatures
      Real gammaBubl1[N + 1], gammaBubl2[N + 1];
      //Gas constant
      parameter Real R_gas = 1.98721;
      //=======================================================================================================
      //Equation Section
    equation
//Calculation of increment step for the total number of points
      delta = 1 / N;
//Empherical parameter (towk) is calculated at different temperatures in the T-x-y mode of operation
      for k in 1:N + 1 loop
        for i in 1:NOC loop
          for j in 1:NOC loop
            towk[k, i, j] = exp(-a[i, j] / (R_gas * T[k]));
          end for;
        end for;
      end for;
//Empherical parameter (tow) is assigned to 1 for T-x-y mode of operation
      for i in 1:NOC loop
        for j in 1:NOC loop
          tow[i, j] = 1;
        end for;
      end for;
//Generation of mole fraction from 0 to 1 in steps of "delta"
      z1[1] = 0;
      for i in 2:N + 1 loop
        z1[i] = z1[i - 1] + delta;
      end for;
      for i in 1:N + 1 loop
        z2[i] = 1 - z1[i];
      end for;
//Calculation of Activity coefficients at different conditions using the function "Gamma_UNIQUAC"
      (gammaBubl1, gammaBubl2) = Binary_Phase_Envelope_UNIQUAC.Gamma_UNIQUAC(Choice, N, NOC, z1, z2, R, Q, tow, towk);
//Bubble point calculation
      for i in 1:N + 1 loop
        P = gammaBubl1[i] * z1[i] * exp(comp[1].VP[2] + comp[1].VP[3] / T[i] + comp[1].VP[4] * log(T[i]) + comp[1].VP[5] * T[i] ^ comp[1].VP[6]) + gammaBubl2[i] * z2[i] * exp(comp[2].VP[2] + comp[2].VP[3] / T[i] + comp[2].VP[4] * log(T[i]) + comp[2].VP[5] * T[i] ^ comp[2].VP[6]);
      end for;
//Phase Equilibria
      for i in 1:N + 1 loop
        K1[i] = gammaBubl1[i] * (Psat[i, 1] / P);
        y1[i] = K1[i] * z1[i];
        y2[i] = 1 - y1[i];
      end for;
//Calculation of vapour pressures at different temperatures
      for i in 1:N + 1 loop
        Psat[i, 1] = Simulator.Files.Thermodynamic_Functions.Psat(comp[1].VP, T[i]);
      end for;
    end T_x_y_UNIQUAC;

    //================================================================================================
    //==============================================================================================================
    //================================================================================================================
  end Binary_Phase_Envelope_UNIQUAC;

  package Binary_Phase_Envelope_UNIFAC
    model P_x_y_UNIFAC
      //Libraries
      import Simulator.*;
      //Extension of Chemsep Database
      Simulator.Files.Chemsep_Database data;
      //Parameter Section
      //Selection of compounds
      parameter data.Methylethylketone meth;
      parameter data.Aceticacid eth;
      //Instantiation of selected compounds
      parameter Simulator.Files.Chemsep_Database.General_Properties comp[NOC] = {meth, eth};
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
        Psat[i] = Simulator.Files.Thermodynamic_Functions.Psat(comp[i].VP, T);
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
    end P_x_y_UNIFAC;

    //====================================================================================================

    model T_x_y_UNIFAC
      //Libraries
      import Simulator.*;
      //Extension of Chemsep Database
      Simulator.Files.Chemsep_Database data;
      //Parameter Section
      //Selection of compounds
      parameter data.Methylethylketone meth;
      parameter data.Aceticacid eth;
      //Instantiation of selected compounds
      parameter Simulator.Files.Chemsep_Database.General_Properties comp[NOC] = {meth, eth};
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
        Psat[i, 1] = Simulator.Files.Thermodynamic_Functions.Psat(comp[1].VP, T[i]);
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
    end T_x_y_UNIFAC;

    //================================================================================================================
  end Binary_Phase_Envelope_UNIFAC;

  package Binary_Phase_Envelope_PR
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

    model PR
      parameter Simulator.Files.Chemsep_Database.General_Properties comp[NOC];
      parameter Integer NOC;
      parameter Real R = 8.314;
      parameter Real kij[NOC, NOC] = Simulator.Files.Thermodynamic_Functions.BIP_PR(NOC, comp.name);
      Real Tr[NOC];
      Real b[NOC];
      Real m[NOC];
      Real q[NOC];
      Real a[NOC];
      Real aij[NOC, NOC];
      Real amL, bmL;
      Real AL, BL, Z_L[3];
      Real ZL;
      Real sum_xa[NOC];
      Real liqfugcoeff[NOC];
      Real amV, bmV;
      Real AV, BV, Z_V[3];
      Real ZV;
      Real sum_ya[NOC];
      Real vapfugcoeff[NOC];
      Real P;
      Real T(start = 273);
      Real Psat[NOC];
      //Bubble and Dew Point Calculation
      Real Tr_bubl[NOC];
      Real a_bubl[NOC];
      Real aij_bubl[NOC, NOC];
      Real Psat_bubl[NOC];
      Real amL_bubl, bmL_bubl;
      Real AL_bubl, BL_bubl, Z_L_bubl[3];
      Real ZL_bubl;
      Real sum_xa_bubl[NOC];
      Real liqfugcoeff_bubl[NOC];
      Real gammaBubl[NOC];
      Real Tbubl(start = 273);
    equation
      for i in 1:NOC loop
        Psat_bubl[i] = Simulator.Files.Thermodynamic_Functions.Psat(comp[i].VP, Tbubl);
        Psat[i] = Simulator.Files.Thermodynamic_Functions.Psat(comp[i].VP, T);
      end for;
//Bubble Point and Dew Point Calculation Routine
      Tr_bubl = Tbubl ./ comp.Tc;
      a_bubl = q .* (1 .+ m .* (1 .- sqrt(Tr_bubl))) .^ 2;
      aij_bubl = {{(1 - kij[i, j]) * sqrt(a_bubl[i] * a_bubl[j]) for i in 1:NOC} for j in 1:NOC};
      (amL_bubl, bmL_bubl, AL_bubl, BL_bubl, Z_L_bubl) = Compresseblity_Factor(b, aij_bubl, P, Tbubl, NOC, x[:]);
      ZL_bubl = min({Z_L_bubl});
      sum_xa_bubl = {sum({x[j] * aij_bubl[i, j] for j in 1:NOC}) for i in 1:NOC};
      liqfugcoeff_bubl = exp(AL_bubl / (BL_bubl * sqrt(8)) * log((ZL_bubl + 2.4142135 * BL_bubl) / (ZL_bubl - 0.414213 * BL_bubl)) .* (b / bmL_bubl .- 2 * sum_xa_bubl / amL_bubl) .+ (ZL_bubl - 1) * (b / bmL_bubl) .- log(ZL_bubl - BL_bubl));
      liqfugcoeff_bubl[:] = gammaBubl[:] .* P ./ Psat_bubl[:];
      P = sum(gammaBubl[:] .* x[:] .* exp(comp[:].VP[2] + comp[:].VP[3] / Tbubl + comp[:].VP[4] * log(Tbubl) + comp[:].VP[5] .* Tbubl .^ comp[:].VP[6]) ./ liqfugcoeff_bubl[:]);
//Calculation of Temperatures at different compositions
      Tr = T ./ comp.Tc;
      b = 0.0778 * R * comp.Tc ./ comp.Pc;
      m = 0.37464 .+ 1.54226 * comp.AF .- 0.26992 * comp.AF .^ 2;
      q = 0.45724 * R ^ 2 * comp.Tc .^ 2 ./ comp.Pc;
      a = q .* (1 .+ m .* (1 .- sqrt(Tr))) .^ 2;
      aij = {{(1 - kij[i, j]) * sqrt(a[i] * a[j]) for i in 1:NOC} for j in 1:NOC};
//Liquid Phase Calculation Routine
      (amL, bmL, AL, BL, Z_L) = Compresseblity_Factor(b, aij, P, T, NOC, x[:]);
      ZL = min({Z_L});
      sum_xa = {sum({x[j] * aij[i, j] for j in 1:NOC}) for i in 1:NOC};
      liqfugcoeff = exp(AL / (BL * sqrt(8)) * log((ZL + 2.4142135 * BL) / (ZL - 0.414213 * BL)) .* (b / bmL .- 2 * sum_xa / amL) .+ (ZL - 1) * (b / bmL) .- log(ZL - BL));
//Vapour Phase Calculation Routine
      (amV, bmV, AV, BV, Z_V) = Compresseblity_Factor(b, aij, P, T, NOC, y[:]);
      ZV = max({Z_V});
      sum_ya = {sum({y[j] * aij[i, j] for j in 1:NOC}) for i in 1:NOC};
      vapfugcoeff = exp(AV / (BV * sqrt(8)) * log((ZV + 2.4142135 * BV) / (ZV - 0.414213 * BV)) .* (b / bmV .- 2 * sum_ya / amV) .+ (ZV - 1) * (b / bmV) .- log(ZV - BV));
    end PR;

    model Phase_Equilibria
      import data = Simulator.Files.Chemsep_Database;
      parameter data.Ethane eth;
      parameter data.Propane prop;
      extends PR(NOC = 2, comp = {eth, prop});
      Real P, T(start = 273), K[NOC], x[NOC](each start = 0.5), y[NOC], Tbubl(start = 273);
    equation
      K[:] = liqfugcoeff[:] ./ vapfugcoeff[:];
      y[:] = K[:] .* x[:];
      sum(x[:]) = 1;
      sum(y[:]) = 1;
    end Phase_Equilibria;

    model Peng_Robinson_Pxy
      import data = Simulator.Files.Chemsep_Database;
      parameter data.Ethane eth;
      parameter data.Propane prop;
      parameter Integer NOC = 2;
      parameter Integer N = 2;
      parameter data.General_Properties comp[NOC] = {eth, prop};
      Phase_Equilibria points[N](each T = 210, each NOC = NOC, each comp = comp, each T(start = 273), each Tbubl(start = 273), each x(each start = 0.5), each y(each start = 0.5));
      Real x1[N], y1[N], x2[N], y2[N], P[N](each start = 101325), Tbubl[N], Temp[N];
    equation
//Generation of Points to compute Bubble Temperature
      points[:].x[1] = x1[:];
      points[:].y[1] = y1[:];
      points[:].x[2] = x2[:];
      points[:].y[2] = y2[:];
      points[:].P = P;
      points[:].Tbubl = Tbubl;
      Temp[1] = Tbubl[1];
      Temp[N] = Tbubl[N];
      for i in 2:N - 1 loop
        Temp[i] = points[i].T;
      end for;
      for i in 1:N loop
        x1[i] = 0.5 + (i - 1) * 0.025;
      end for;
    end Peng_Robinson_Pxy;

    model Peng_Robinson_Txy
      import data = Simulator.Files.Chemsep_Database;
      parameter data.Ethane eth;
      parameter data.Propane prop;
      parameter Integer NOC = 2;
      parameter Integer N = 1;
      parameter data.General_Properties comp[NOC] = {eth, prop};
      Phase_Equilibria points[N](each P = 101325, each NOC = NOC, each comp = comp, each T(start = 273), each Tbubl(start = 273), each x(each start = 0.5), each y(each start = 0.5));
      Real x[N, NOC], y[N, NOC], T[N], Tbubl[N], T_PR[N];
    equation
      points[:].x = x;
      points[:].y = y;
      points[:].T = T;
      points[:].Tbubl = Tbubl;
      T_PR[1] = Tbubl[1];
      T_PR[N] = Tbubl[N];
      for i in 2:N - 1 loop
        T_PR[i] = T[i];
      end for;
      for i in 1:N loop
        x[i, 1] = 0 + (i - 1) * 0.025;
      end for;
    end Peng_Robinson_Txy;
  end Binary_Phase_Envelope_PR;

  package Binary_Phase_Envelope_NRTL
    model NRTL_model
      import Simulator.Files.Thermodynamic_Functions.*;
      gammaNRTL_model Gamma(NOC = NOC, comp = comp, molFrac = x[:], T = T);
      Real density[NOC], BIPS[NOC, NOC, 2];
    equation
      gamma = Gamma.gamma;
      BIPS = Gamma.BIPS;
      for i in 1:NOC loop
        density[i] = Dens(comp[i].LiqDen, comp[i].Tc, T, P);
      end for;
      for i in 1:NOC loop
        K[i] = gamma[i] * Psat(comp[i].VP, T) / P;
      end for;
    end NRTL_model;

    model gammaNRTL_model
      parameter Integer NOC;
      parameter Simulator.Files.Chemsep_Database.General_Properties comp[NOC];
      Real molFrac[NOC], T;
      Real gamma[NOC];
      Real tau[NOC, NOC], G[NOC, NOC], alpha[NOC, NOC], A[NOC, NOC], BIPS[NOC, NOC, 2];
      Real sum1[NOC], sum2[NOC];
      constant Real R = 1.98721;
    equation
      A = BIPS[:, :, 1];
      alpha = BIPS[:, :, 2];
      tau = A ./ (R * T);
      for i in 1:NOC loop
        for j in 1:NOC loop
          G[i, j] = exp(-alpha[i, j] * tau[i, j]);
        end for;
      end for;
      for i in 1:NOC loop
        sum1[i] = sum(molFrac[:] .* G[:, i]);
        sum2[i] = sum(molFrac[:] .* tau[:, i] .* G[:, i]);
      end for;
      for i in 1:NOC loop
        log(gamma[i]) = sum(molFrac[:] .* tau[:, i] .* G[:, i]) / sum(molFrac[:] .* G[:, i]) + sum(molFrac[:] .* G[i, :] ./ sum1[:] .* (tau[i, :] .- sum2[:] ./ sum1[:]));
      end for;
    end gammaNRTL_model;

    model base
      import data = Simulator.Files.Chemsep_Database;
      parameter Integer NOC;
      parameter Real BIP[NOC, NOC, 2];
      parameter data.General_Properties comp[NOC];
      extends NRTL_model(BIPS = BIP);
      Real P, T(start = 300), gamma[NOC], K[NOC], x[NOC](each start = 0.5), y[NOC];
    equation
      y[:] = K[:] .* x[:];
      sum(x[:]) = 1;
      sum(y[:]) = 1;
    end base;

    model Onehexene_Acetone_Txy
      import data = Simulator.Files.Chemsep_Database;
      parameter data.Onehexene ohex;
      parameter data.Acetone acet;
      parameter Integer NOC = 2;
      parameter Real BIP[NOC, NOC, 2] = Simulator.Files.Thermodynamic_Functions.BIPNRTL(NOC, comp.CAS);
      parameter data.General_Properties comp[NOC] = {ohex, acet};
      base points[41](each P = 1013250, each NOC = NOC, each comp = comp, each BIP = BIP);
      Real x[41, NOC], y[41, NOC], T[41];
    equation
      points[:].x = x;
      points[:].y = y;
      points[:].T = T;
      for i in 1:41 loop
        x[i, 1] = 0 + (i - 1) * 0.025;
      end for;
    end Onehexene_Acetone_Txy;

    model Onehexene_Acetone_Pxy
      import data = Simulator.Files.Chemsep_Database;
      parameter data.Onehexene ohex;
      parameter data.Acetone acet;
      parameter Integer NOC = 2;
      parameter Real BIP[NOC, NOC, 2] = Simulator.Files.Thermodynamic_Functions.BIPNRTL(NOC, comp.CAS);
      parameter data.General_Properties comp[NOC] = {ohex, acet};
      base points[41](each T = 424, each NOC = NOC, each comp = comp, each BIP = BIP);
      Real x[41, NOC], y[41, NOC], P[41];
    equation
      points[:].x = x;
      points[:].y = y;
      points[:].P = P;
      for i in 1:41 loop
        x[i, 1] = 0 + (i - 1) * 0.025;
      end for;
    end Onehexene_Acetone_Pxy;
  end Binary_Phase_Envelope_NRTL;
end Binary_Phase_Envelope;
