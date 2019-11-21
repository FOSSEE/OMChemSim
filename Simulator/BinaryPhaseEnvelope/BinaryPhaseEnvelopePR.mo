within Simulator.BinaryPhaseEnvelope;

package BinaryPhaseEnvelopePR
  extends Modelica.Icons.ExamplesPackage;
  function CompresseblityFactor
    extends Modelica.Icons.Function;
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
  end CompresseblityFactor;

  model PR
    parameter Simulator.Files.ChemsepDatabase.GeneralProperties comp[NOC];
    parameter Integer NOC;
    parameter Real R = 8.314;
    parameter Real kij[NOC, NOC] = Simulator.Files.ThermodynamicFunctions.BIPPR(NOC, comp.name);
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
      Psat_bubl[i] = Simulator.Files.ThermodynamicFunctions.Psat(comp[i].VP, Tbubl);
      Psat[i] = Simulator.Files.ThermodynamicFunctions.Psat(comp[i].VP, T);
    end for;
//Bubble Point and Dew Point Calculation Routine
    Tr_bubl = Tbubl ./ comp.Tc;
    a_bubl = q .* (1 .+ m .* (1 .- sqrt(Tr_bubl))) .^ 2;
    aij_bubl = {{(1 - kij[i, j]) * sqrt(a_bubl[i] * a_bubl[j]) for i in 1:NOC} for j in 1:NOC};
    (amL_bubl, bmL_bubl, AL_bubl, BL_bubl, Z_L_bubl) = CompresseblityFactor(b, aij_bubl, P, Tbubl, NOC, x[:]);
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
    (amL, bmL, AL, BL, Z_L) = CompresseblityFactor(b, aij, P, T, NOC, x[:]);
    ZL = min({Z_L});
    sum_xa = {sum({x[j] * aij[i, j] for j in 1:NOC}) for i in 1:NOC};
    liqfugcoeff = exp(AL / (BL * sqrt(8)) * log((ZL + 2.4142135 * BL) / (ZL - 0.414213 * BL)) .* (b / bmL .- 2 * sum_xa / amL) .+ (ZL - 1) * (b / bmL) .- log(ZL - BL));
//Vapour Phase Calculation Routine
    (amV, bmV, AV, BV, Z_V) = CompresseblityFactor(b, aij, P, T, NOC, y[:]);
    ZV = max({Z_V});
    sum_ya = {sum({y[j] * aij[i, j] for j in 1:NOC}) for i in 1:NOC};
    vapfugcoeff = exp(AV / (BV * sqrt(8)) * log((ZV + 2.4142135 * BV) / (ZV - 0.414213 * BV)) .* (b / bmV .- 2 * sum_ya / amV) .+ (ZV - 1) * (b / bmV) .- log(ZV - BV));
  end PR;

  model PhaseEquilibria
    import data = Simulator.Files.ChemsepDatabase;
    parameter data.Ethane eth;
    parameter data.Propane prop;
    extends PR(NOC = 2, comp = {eth, prop});
    Real P, T(start = 273), K[NOC], x[NOC](each start = 0.5), y[NOC], Tbubl(start = 273);
  equation
    K[:] = liqfugcoeff[:] ./ vapfugcoeff[:];
    y[:] = K[:] .* x[:];
    sum(x[:]) = 1;
    sum(y[:]) = 1;
  end PhaseEquilibria;

  model PengRobinsonPxy
    extends Modelica.Icons.Example;
    import data = Simulator.Files.ChemsepDatabase;
    parameter data.Ethane eth;
    parameter data.Propane prop;
    parameter Integer NOC = 2;
    parameter Integer N = 2;
    parameter data.GeneralProperties comp[NOC] = {eth, prop};
    PhaseEquilibria points[N](each T = 210, each NOC = NOC, each comp = comp, each T(start = 273), each Tbubl(start = 273), each x(each start = 0.5), each y(each start = 0.5));
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
  end PengRobinsonPxy;

  model PengRobinsonTxy
    extends Modelica.Icons.Example;
    import data = Simulator.Files.ChemsepDatabase;
    parameter data.Ethane eth;
    parameter data.Propane prop;
    parameter Integer NOC = 2;
    parameter Integer N = 10;
    parameter data.GeneralProperties comp[NOC] = {eth, prop};
    PhaseEquilibria points[N](each P = 101325, each NOC = NOC, each comp = comp, each T(start = 273), each Tbubl(start = 273), each x(each start = 0.5), each y(each start = 0.5));
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
  end PengRobinsonTxy;
end BinaryPhaseEnvelopePR;
