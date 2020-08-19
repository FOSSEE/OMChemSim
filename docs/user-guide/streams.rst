.. _streams:

Streams
========
**Streams** is a modelica package available under Simulator. It consists of models as:

 - ``MaterialStream``
 - ``EnergyStream``

.. toctree::
   :includehidden:


Material Stream
-----------------   
A **Material Stream** represents whatever enters and leaves the simulation passing through the unit operations. 
It is one of the important models to be used in any simulation. To simulate a material stream, following inputs should be given:

 - Flash Specification
 - Molar Flowrate
 - Mole Fraction of Components
 
Flash specification is a binarry combination of different thermophysical properties which needs to be passed as input variables as mentioned above. 
It can be of following types:

 1. TP:  Temperature and Pressure
 2. PH:  Pressure and Enthalpy
 3. PVF: Pressure and Vapor Fraction
 4. TVF: Temperature and Vapor Fraction
 5. PS:  Pressure and Entropy

To simulate a material stream, one needs to extend the ``MaterialStream`` model along with the necessary property method from ``ThermodynamicPackages``.

Simulating a Material Stream
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
There are two different approach by which a material stream can be simulated. First one is to create a model where the ``MaterialStream``, 
and necessary property method from ``ThermodynamicPackages`` are instantiated, components are called from ``ChemsepDatabase`` 
and required input variables are passed through ``equation`` section.

Other way is to create a model where only the ``MaterialStream`` and necessary property method from ``ThermodynamicPackages`` are extended. Then this model is
instantiated in another new model where the components are called from the ``ChemsepDatabase`` and input variables are passed through ``equation`` section.
One might think that there is not much difference between the two approaches. However, the second one is a more useful one when has to simulate a flowsheet
with multiple material streams. We wil explain more about this when we simulate a flowsheet. 
Creating a material stream using both the approaches is explained below:

Let us consider a ternary system consisting of Methanol, Ethanol and Water. 
The stream is at pressure of 101325 Pa and temperature of 351 K. 
Mole fractions of these componente are 0.33, 0.33, 0.34 respectively. Molar flow rate of
the stream is 100 mol/s.


Here are step by step explaination as to how to create and simulate this material stream by first approach.

 1. First, create a model named ``TPflash``.
 
 2. Next, create an instance of ``ChemsepDatabase`` ::

     import data = Simulator.Files.ChemsepDatabase;
  
 3. Then, create instances of components to be used ::
 
     parameter data.Methanol meth;
     parameter data.Ethanol eth;
     parameter data.Water wat;
	
 4. Extend ``MaterialStream`` model  available under ``Streams``. Here we must pass a few arguments such as 
 number of components ``Nc`` and component array ``C`` ::
 
     extends Streams.MaterialStream(Nc = 3, C = {meth, eth, wat});
   
 5. Extend the necessary property method from ``ThermodynamicPackages``. Here, we are extending the ``RaoultsLaw`` ::
 
     extends Simulator.Files.ThermodynamicPackages.RaoultsLaw;
 
 6. Specify values of input variables in equation section. It is clear from the model name that we will be doing a TP flash
 therefore, we will pass temperature, pressure, molar flow rate and mole fraction of components as input variables ::
 
     P = 101325;
     T = 351;
     x_pc[1, :] = {0.33, 0.33, 0.34};
     F_p[1] = 100;
	 
This completes the material stream. Now, click on simulate button to simulate the ``TPflash`` model. Alternatively, you can also
find this package named ``TPflash`` in the ``Simulator`` library under ``MaterialStream`` package under ``Examples``.
	 
Now, let us see how we can create and simulate the material stream by second approach. We will consider a different problem statement here.

Let us consider a binary system consisting of Benzene and Toluene. 
The stream is at pressure of 101325 Pa and temperature of 368 K. 
Molar flow rate of the stream is 100 mol/s and the components are in equimolar composition.

 1. Create a package called ``CompositeMS``
 
 2. Create new model named ``MS`` in the package ``CompositeMS``
 
 3. Extend ``MaterialStream`` model inside ``MS`` ::
  
     extends Simulator.Streams.MaterialStream;
	
 4. Extend the necessary property method from ``ThermodynamicPackages`` inside ``MS`` ::
 
     extends Simulator.Files.ThermodynamicPackages.RaoultsLaw;
 
 5. Create another new model called ``MatStreamSimulation`` inside ``CompositeMS``

 6. Now, inside model ``MatStreamSimulation``, create an instance of ``ChemsepDatabase`` ::
     
	 import data = Simulator.Files.ChemsepDatabase;

 7. Create instances of components to be used ::
     
	 parameter data.Benzene benz;
	 parameter data.Toluene tol;

 8. Create an Integer parameter for number of components (Nc) ::
 
     parameter Integer Nc = 2;
	 
 9. Create an component array C to access the properties of components from `ChemsepDatabase` ::
 
     parameter data.GeneralProperties C[Nc] = {benz, tol};
	 
 10. Now, we will create an instance of the model ``MS``. 
     To do this, open diagram view of ``MatStreamSimulation`` model, drag & drop ``MS`` as shown in fig. Name the model as ``ms1``
 
 11. Switch to text view there will be generated code for instantiation of "MS". Pass the values of ``Nc`` and ``C`` 
     as argument of the material stream instance ``S1`` ::
	 
	  Simulator.Examples.CompositeMS.MS S1(Nc = Nc, C = C) annotation( ...);
	  
 12. Specify values of input variables in equation section. Here, we will pass temperature, pressure, molar flow rate and mole fraction of components ::
 
      P = 101325;
      T = 368;
      x_pc[1, :] = {0.5, 0,5};
      F_p[1] = 100;
	 
This completes the material stream package. Now click on ``Simulate`` button to simulate the ``MatStreamSimulation`` model. Switch to Plotting Perspective to view the results.
 
 .. note::
 		 You can also find this example named ``CompositeMS`` in the ``Simulator`` library under ``Examples`` package.
	 
Energy Stream
-----------------

This model is used for dispalying heat loss/required for the unit operations which involve energy balance. This model can be
instantiated by dragging and dropping. The code looks like follows ::

 Simulator.Streams.EnergyStream E1 annotation(....);
 
We will discuss about this in detail when we describe unit operations which requires energy stream.