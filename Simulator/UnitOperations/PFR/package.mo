within Simulator.UnitOperations;

package PFR "Package of a Plug Flow Reactor to calculate the outlet stream mole fraction of components"
  extends Modelica.Icons.Package;
  
  annotation(
    Documentation(info = "<html><head></head><body>This is a package of model and functions required for calculationg outlet mole fraction of components in a Plug Flow Reactor. It contains following fies and models:<div><br></div><div><ol><li><a href=\"modelica://Simulator.UnitOperations.PFR.PFR\">PFR</a>: Model of a Plug Flow Reactor along with its terformance equation to calculate the mole fraction of the components at outlet</li><li><a href=\"modelica://Simulator.UnitOperations.PFR.Integral\">Integral</a>: Function to define the integral part used in the performance equation of a plug floiw reactor</li><li><a href=\"modelica://Simulator.UnitOperations.PFR.PerformancePFR\">PerformancePFR</a>: Function to return the integral of the Integral function using an adaptive Lobatto rule</li></ol></div></body></html>"));  
end PFR;
