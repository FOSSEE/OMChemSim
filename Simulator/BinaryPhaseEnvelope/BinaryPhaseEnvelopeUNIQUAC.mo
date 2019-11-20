within Simulator.BinaryPhaseEnvelope;

package BinaryPhaseEnvelopeUNIQUAC
  extends Modelica.Icons.ExamplesPackage;
  //==============================================================================================================

  function GammaUNIQUAC
  extends Modelica.Icons.Function;
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
  end GammaUNIQUAC;

  //================================================================================================
  //Binary Phase Envelope
  //Envelope Type : P-x-y
  //Thermodynamic-Model : UNIQUAC
  //Nature of System    : Azeotropic System
  //========================================================================================

  model PxyUNIQUAC
    extends Modelica.Icons.Example;
    //Libraries
    import Simulator.*;
    //Extension of Chemsep Database
    Simulator.Files.ChemsepDatabase data;
    //Parameter Section
    //Selection of compounds
    parameter data.Water wat;
    parameter data.Ethanol eth;
    //Instantiation of selected compounds
    parameter Simulator.Files.ChemsepDatabase.GeneralProperties comp[NOC] = {wat, eth};
    parameter Integer NOC = 2 "Number of components";
    parameter Integer Choice = 1 "System choice of Txy or Pxy";
    parameter Real T(unit = "K") = 315 "System Temperature";
    //Empherical parameter (towk) at different temperatures
    //Note : The below value will be active only in the T-x-y phase envelope routine
    Real towk[N + 1, NOC, NOC];
    parameter Integer N = 40 "Number of points of data generation";
    Real delta "Increment step";
    parameter Real a[NOC, NOC] = Simulator.Files.ThermodynamicFunctions.BIPUNIQUAC(NOC, comp.name) "Interaction Parameters";
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
      Psat[i] = Simulator.Files.ThermodynamicFunctions.Psat(comp[i].VP, T);
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
    tow = Simulator.Files.ThermodynamicFunctions.TowUNIQUAC(NOC, a, T);
//Generation of mole fraction from 0 to 1 in steps of "delta"
    z1[1] = 0;
    for i in 2:N + 1 loop
      z1[i] = z1[i - 1] + delta;
    end for;
    for i in 1:N + 1 loop
      z2[i] = 1 - z1[i];
    end for;
//Calculation of Activity coefficients at different conditions using the function "Gamma_UNIQUAC"
    (gammaBubl1, gammaBubl2) = BinaryPhaseEnvelopeUNIQUAC.GammaUNIQUAC(Choice, N, NOC, z1, z2, R, Q, tow, towk);
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
  end PxyUNIQUAC;

  //=====================================================================================================

  model TxyUNIQUAC
    extends Modelica.Icons.Example;
    //Libraries
    import Simulator.*;
    //Extension of Chemsep database
    Simulator.Files.ChemsepDatabase data;
    //Parameter Section
    //Selection of compounds
    parameter data.Water wat;
    parameter data.Ethanol eth;
    //Instantiation of selected compounds
    parameter Simulator.Files.ChemsepDatabase.GeneralProperties comp[NOC] = {wat, eth};
    parameter Integer Choice = 2 "System choice of Txy or Pxy";
    parameter Integer NOC = 2 "Number of components";
    parameter Real P(unit = "Pa") = 101325 "System Pressure";
    parameter Integer N = 40 "Number of points of data generation";
    //UNIQUAC Parameters
    parameter Real R[NOC] = comp.UniquacR;
    parameter Real Q[NOC] = comp.UniquacQ;
    parameter Real a[NOC, NOC] = Simulator.Files.ThermodynamicFunctions.BIPUNIQUAC(NOC, comp.name) "Interaction temperatures";
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
    (gammaBubl1, gammaBubl2) = BinaryPhaseEnvelopeUNIQUAC.GammaUNIQUAC(Choice, N, NOC, z1, z2, R, Q, tow, towk);
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
      Psat[i, 1] = Simulator.Files.ThermodynamicFunctions.Psat(comp[1].VP, T[i]);
    end for;
  end TxyUNIQUAC;

  //================================================================================================
  //==============================================================================================================
  //================================================================================================================
end BinaryPhaseEnvelopeUNIQUAC;
