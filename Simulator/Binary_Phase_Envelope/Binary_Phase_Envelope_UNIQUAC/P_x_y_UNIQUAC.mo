within Simulator.Binary_Phase_Envelope.Binary_Phase_Envelope_UNIQUAC;

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
