within Simulator.Files.ChemsepDatabase;

model GeneralProperties "Model to declare the variables for thermophysical properties"
    extends Modelica.Icons.Record;
  parameter Integer SN "Serial Number";
  parameter String name "Compound Name";
  parameter String CAS "CAS Number";
  parameter Real Tc (unit="K") "Critical Temperature";
  parameter Real Pc (unit="Pa") "Critical Pressure";
  parameter Real Vc (unit="m3/kmol") "Critical Volume";
  parameter Real Cc (unit="-") "Critical Compressibility Factor";
  parameter Real Tb (unit="K") "Boiling Point Temperature";
  parameter Real Tm (unit="K") "Melting Point Temperature";
  parameter Real TT (unit="K") "Triple Point Temperature";
  parameter Real TP (unit="Pa") "Triple Point Pressure";
  parameter Real MW (unit="-") "Molecular Weight";
  parameter Real LVB (unit="m3/kmol") "Liquid Molar Volume at Normal Boiling Point";
  parameter Real AF (unit="-") "Acentric Factor";
  parameter Real SP (unit="J0.5/m1.5") "Solubility Parameter";
  parameter Real DM (unit="Coulomb.m") "Dipole Moment";
  parameter Real SH (unit="J/kmol") "Absolute Enthalpy";
  parameter Real IGHF (unit="J/kmol") "Standard Heat of Formation";
  parameter Real GEF (unit="J/kmol") "Gibbs Energy of Formation";
  parameter Real AS (unit="J/kmol/K") "Absolute Entropy";
  parameter Real HFMP (unit="J/kmol") "Heat of Fusion at Melting Point";
  parameter Real HOC (unit="J/kmol") "Heat of Combustion";
  parameter Real UniquacR (unit="-") "UNIQUAC r";
  parameter Real UniquacQ (unit="-") "UNIQUAC q";
  parameter Real LiqDen[6] (each unit="kmol/m3") "Liquid Density Coefficients";
  parameter Real VP[6] (each unit="Pa") "Vapor Pressure Coefficients";
  parameter Real LiqCp[6] (each unit="J/kmol/K") "Liquid Heat Capacity Coefficients";
  parameter Real HOV[6] (each unit="J/kmol") "Heat of Vaporization Coefficients";
  parameter Real VapCp[6] (each unit="J/kmol/K") "Ideal Gas Heat Capacity Coefficients";
  parameter Real LiqVis[6] (each unit="Pa s") "Liquid Viscosity Coefficients";
  parameter Real VapVis[6] (each unit="Pa s") "Vapor Viscosity Coefficients";
  parameter Real LiqK[6] (each unit="W/m/K") "Liquid Thermal Conductivity Coefficients";
  parameter Real VapK[6] (each unit="W/m/K") "Vapor Thermal Conductivity Coefficients";
  parameter Real Racketparam (unit="-") "Racket Parameter";
  parameter Real ChaoSeadAF (unit="-") "Chao-Seader Accentric Factor";
  parameter Real ChaoSeadSP (unit="J0.5/m1.5") "Shao-Seader Solubility Parameter";
  parameter Real ChaoSeadLV (unit="m3/kmol") "Chao-Seader Liquid Volume";
  annotation(
    Documentation(info = "<html><head></head><body><div>This model is to define/declare the variables for all the thermopysical properties that are available for the components in Chemsep Database.</div><div><br></div>In this model, variables for the following properties are defined:<div><br><table border=\"1\" cellspacing=\"0\" cellpadding=\"2\"><caption align=\"bottom\"><br></caption><caption align=\"bottom\"><br></caption><tbody><tr><th>Variables</th><th>Description</th><th>Units</th></tr><tr><td>SN</td><td>Serial Number</td><td>Not Applicable</td></tr><tr><td>name</td><td>Name of the Compound</td><td>Not Applicable</td></tr><tr><td>CAS</td><td>CAS ID</td><td>Not Applicable</td></tr><tr><td>Tc</td><td>Critical Temperature</td><td>K </td></tr><tr><td>Pc</td><td>Critical Pressure</td><td>Pa</td></tr><tr><td>Vc</td><td>Critical Volume</td><td>m3/kmol</td></tr><tr><td>Cc</td><td>Critial Compressibility Factor</td><td>No Units</td></tr><tr><td>Tb</td><td>Boiling Point Temperature</td><td>K </td></tr><tr><td>Tm</td><td>Melting Point Temperature</td><td>K </td></tr><tr><td>TT</td><td>Triple Point Temperature</td><td>K </td></tr><tr><td>TP</td><td>Triple Point Pressure</td><td>Pa</td></tr><tr><td>MW</td><td>Molecular Weight</td><td>kg/kmol</td></tr><tr><td>LVB</td><td>Liquid Molar Volume at Normal Boiling Point</td><td>m3/kmol</td></tr><tr><td>AF</td><td>Accentric Factor</td><td>No Units</td></tr><tr><td>SP</td><td>Solubility Parameter</td><td>J0.5/m1.5</td></tr><tr><td>DM</td><td>Dipole Moment</td><td>Coulumb.m</td></tr><tr><td>SH</td><td>Absolute Enthalpy</td><td>J/kmol</td></tr><tr><td>IGHF</td><td>Standard Heat of Formation</td><td>J/kmol</td></tr><tr><td>GEF</td><td>Gibbs Energy of Formation</td><td>J/kmol</td></tr><tr><td>AS</td><td>Absolute Entropy</td><td>J/[kmol.K]</td></tr><tr><td>HFMP</td><td>Heat of Fusion at Melting Point</td><td>J/kmol</td></tr><tr><td>HOC</td><td>Heat of Combustion</td><td>J/kmol</td></tr><tr><td>UniquacR</td><td>UNIQUAC R</td><td>No Units</td></tr><tr><td>UniquacQ</td><td>UNIQUAC Q</td><td>No Units</td></tr><tr><td>Racketparam</td><td>Racket parameter</td><td>No Units</td></tr><tr><td>ChaoSeadAF</td><td>Chao-Seader Accentric Factor</td><td>No Units</td></tr><tr><td>ChaoSeadSP</td><td>Chao-Seader Solubility Parameter</td><td>J0.5/m1.5</td></tr><tr><td>ChaoSeadLV</td><td>Chao-Seader Liquid Volume</td><td>m3/kmol</td></tr></tbody></table>Aditionally, array variables for the following temperature dependent properties are also defined.</div><div><br><table border=\"1\" cellspacing=\"0\" cellpadding=\"2\">
  <tbody>
   <tr><th>Variables</th><th>Description</th><th>Units</th></tr>
    <tr><td>LiqDen[6]<span class=\"Apple-tab-span\" style=\"white-space:pre\">	</span>&nbsp;</td>
    <td>Liquid Density Coefficients &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;&nbsp;</td>
    <td>kmol/m3 &nbsp; &nbsp; &nbsp; &nbsp;</td>
  </tr>
     <tr>
    <td>VP[6]</td>
    <td>Vapor Pressure Coefficients</td>
    <td>Pa</td>
  </tr>  
   <tr>
    <td>LiqCp[6]</td>
    <td>Liquid Heat Capacity Coefficients</td>
    <td>J/[kmol.K]</td>
  </tr>     <tr>
    <td>HOV[6]</td>
    <td>Heat of Vaporization Coefficients</td>
    <td>J/kmol</td>
  </tr>
     <tr>
    <td>VapCp[6]</td>
    <td>Ideal Gas Heat Capacity Coefficients</td>
    <td>J/[kmol.K]</td>
  </tr>       <tr>
    <td>LiqVis[6]</td>
    <td>Liquid Viscosity Coefficients</td>
    <td>Pa s</td>
  </tr>
   <tr>
    <td>VapVis[6]</td>
    <td>Vapor Viscosity Coefficients</td>
    <td>Pa s</td>
  </tr>
   <tr>
    <td>LiqK[6]</td>
    <td>Liquid Thermal Conductivity Coefficients</td>
    <td>W/[m.K]</td>
  </tr>
   <tr>
    <td>VapK[6]</td>
    <td>Vapor Thermal Conductivity Coefficients</td>
    <td>W/[m.K]</td></tr></tbody></table><br></div><div>

The first indice of the array refers to the equation number from the Chemsep Database which will be used to calculate the property value as function of temperature. Remaining indices are the actual coefficients that are used in the equation to calculate the property.</div></body></html>"));
end GeneralProperties;
