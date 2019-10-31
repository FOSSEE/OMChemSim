within Simulator.Binary_Phase_Envelope.Binary_Phase_Envelope_UNIQUAC;

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
