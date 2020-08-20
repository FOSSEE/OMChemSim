within Simulator;

package Examples "Examples that demonstrate the usage of the chemical components, unit operations and thermodynamic packages"
  extends Modelica.Icons.ExamplesPackage;








































  annotation(
    Documentation(info = "<html><head></head><body><p style=\"font-size: 12px;\"><strong>Examples</strong>&nbsp;package is a library of examples demonstarting the use of different Unit Operations model.</p><p style=\"font-size: 12px;\">This is a short&nbsp;<strong>Documentation</strong>&nbsp;for the Examples library. All the example models inside this library have their own documentations that can be accessed by the following links:</p><p></p><table border=\"1\" cellspacing=\"0\" cellpadding=\"2\"><caption align=\"bottom\"><br></caption><caption align=\"bottom\"><br></caption><tbody>
<tr><td><a href=\"modelica://Simulator.Examples.CompositeMS\">Material Stream</a></td><td>Example of simulating a <b>Material Stream</b> with two components at given composition, pressure and temperature.</td></tr>
<tr><td><a href=\"modelica://Simulator.Examples.Mixer\">Mixer</a></td><td><span style=\"font-family: Arial, Helvetica, sans-serif; font-size: 13px; orphans: 2; widows: 2;\">Example of simulating a <b>Mixer</b>&nbsp;to mix six material streams comprising three components with different composition and thermodynamic properties into one outlet stream.</span></td></tr>
<tr><td><a href=\"modelica://Simulator.Examples.Heater\">Heater</a></td><td><span style=\"font-size: 12px;\">Example of simulating a </span><b style=\"font-size: 12px;\">Heater</b><span style=\"font-size: 12px;\">&nbsp;to heat a material stream with three components from a lower temperature to a higher temperature by specifying amount of heat added.</span></td></tr>
<tr><td><a href=\"modelica://Simulator.Examples.HeatExchanger\">HeatExchanger</a></td><td>Examples of simulating a <b>Heat Exchanger</b> to calculate the outlet material stream temperatures by specifying different heat exchanger properties.</td></tr>
<tr><td><a href=\"modelica://Simulator.UnitOperations.Cooler\">Cooler</a></td><td><span style=\"font-size: 12px;\">Example of simulating a&nbsp;</span><b style=\"font-size: 12px;\">Cooler</b><span style=\"font-size: 12px;\">&nbsp;to cool a material stream with three components from a higher temperature to a lower temperature.</span></td></tr>
<tr><td><a href=\"modelica://Simulator.Examples.Valve\">Valve</a></td><td>Example of simulating a <b>Valve</b> to regulate the pressure of a material stream with three components.</td></tr><tr><td><a href=\"modelica://Simulator.Examples.ShortcutColumn\">ShortcutColumn</a></td><td><span style=\"font-family: Arial, Helvetica, sans-serif; font-size: 13.3333px; orphans: 2; widows: 2;\">Example of simulating a <b>Shortcut Column</b> to calculate&nbsp;minimum reflux ratio and number of stages desired for separating a mixture of given purity.<br></span></td></tr>
<tr><td><a href=\"modelica://Simulator.Examples.CompoundSeparator\">CompoundSeparator</a></td><td>Example of simulating a <b>Compound Separator</b> separating two component system by specifying material balance</td></tr>
<tr><td><a href=\"modelica://Simulator.Examples.Flash\">FlashColumn</a></td><td>Example of simulating&nbsp;<b>Flash Column</b> to separate vapor and liquid phases from a mixed phase material stream </td></tr>
<tr><td><a href=\"modelica://Simulator.Examples.Splitter\">Splitter</a></td><td><span style=\"font-family: Arial, Helvetica, sans-serif; font-size: 13px; orphans: 2; widows: 2;\">Example of a&nbsp;</span><b style=\"font-family: Arial, Helvetica, sans-serif; font-size: 13px; orphans: 2; widows: 2;\">Splitter</b><span style=\"font-family: Arial, Helvetica, sans-serif; font-size: 13px; orphans: 2; widows: 2;\">&nbsp;used to split up one material stream into two, while executing all the mass and energy balances</span> </td></tr>
<tr><td><a href=\"modelica://Simulator.Examples.Pump\">CentrifugalPump</a></td><td>Model of a <b>Centrifugal Pump</b>&nbsp;to increase the pressure of a liquid stream while specifying the pressure increase.</td></tr>
<tr><td><a href=\"modelica://Simulator.Examples.Compressor\">AdiabaticCompressor</a></td><td><span style=\"font-weight: normal;\">Example of an </span><b>Adiabatic Compressor</b>&nbsp;to increase the pressure of a gaseous stream while specifying the pressure increase.</td></tr>
<tr><td><a href=\"modelica://Simulator.Examples.Expander\">AdiabaticExpander</a></td><td>Example of an <b>Adiabatic Expander</b> to reduce the pressure of a gaseous stream while specifying the pressure drop.</td></tr>
<tr><td><a href=\"modelica://Simulator.Examples.ConversionReactor\">ConversionReactor</a></td><td>Example of a <b>Conversion Reactor</b> to calculate the outlet stream mole fraction of components while specifying the component conversion.</td></tr>
<tr><td><a href=\"modelica://Simulator.Examples.EquilibriumReactor\">EquilibriumReactor</a></td><td>Examples of&nbsp;<b>Equilibrium Reactor</b> to calculate the outlet stream mole fraction of components and conversion when specifying the equilibrium constant.</td></tr>
<tr><td><a href=\"modelica://Simulator.Examples.PFR\">PFR</a></td><td>Example of a <b>Plug Flow Reactor</b> to calculate the reactor volume from given rate kinetics.</td></tr>
<tr><td><a href=\"modelica://Simulator.Examples.CSTR\">CSTR</a></td><td>Examples of&nbsp;<b>CSTR</b> to calculate the conversion from given rate kinetics.</td></tr>
<tr><td><a href=\"modelica://Simulator.Examples.Distillation\">DistillationColumn</a></td><td>Examples of&nbsp;<b>Distillation Columns</b> separating a binary mixture of Benzene and Toluene.</td></tr>
<tr><td><a href=\"modelica://Simulator.Examples.Absorption\">AbsorptionColumn</a></td><td>Example of an&nbsp;<b>Absorption Column</b>&nbsp;separating a gaseous mixtue of Air and Acetone using Water.</td></tr>
</tbody></table><p></p></body></html>"));
end Examples;
