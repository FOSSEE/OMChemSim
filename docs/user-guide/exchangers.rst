.. _exchangers:

Exchangers
===========


Heater
-------

The **Heater** is used to simulate the heating process of a material stream.

The heater model have following connection ports:

 * Two Material Streams: feed and outlet stream
 * One Energy Stream: heat added

Following calculation parameters must be provided to the heater:

 - Pressure Drop ``Pdel``
 - Efficiency ``Eff``

The above variables have been declared of type parameter Real. 
During simulation, their values can specified directly under Heater Specifications by double clicking on the heater model instance.


In addition to the above parameters, any one additional variable from the below list must be provided for the model to simulate successfully:

 - Outlet Temperature ``Tout``
 - Temperature Increase ``Tdel``
 - Heat Added ``Q``
 - Outlet Stream Vapor Phase Mole Fraction ``xvapout``

These variables are declared of type Real.
During simulation, value of one of these variables need to be defined in the equation section.

Simulating a Heater
~~~~~~~~~~~~~~~~~~~

 1. Create a package named ``Heater``
 
 2. Create a model named ``MS`` inside ``Heater``. This is to extend ``MaterialStream`` model
 
 3. Extend the model ``MaterialStream`` and necessary property method from ``ThermodynamicPackages`` ::
 
        extends Simulator.Streams.MaterialStreams;
        extends Simulator.Files.ThermodynamicPackages.RaoultsLaw;
	 

 4. Create another new model named ``HeaterSimulation``
  
 5. Similar to the ``MaterialStream`` example model, import ``ChemsepDatabase`` and create variables 
    for the compounds which are to be used from ``ChemsepDatabase`` ::
	 
        import data = Simulator.Files.ChemsepDatabase;
        parameter data.Methanol meth;
        parameter data.Ethanol eth;
        parameter data.Water wat;
	 
 6. Define variables for Number of components ``Nc`` and component array ``C``. 
    Also assign the variables created for the compounds to the component array ::
	 
        parameter Integer Nc = 3;
        parameter data.GeneralProperties C[Nc] = {meth, eth, wat};
    
 7. Now, create three instances of the ``MaterialStream`` model ``MS`` as we require one material stream which will 
    go as input and two material streams which will come as output. To do this, open diagram view of ``HeaterSimulation`` model, drag & drop ``MS`` teice as shown in fig. Name the instances as ``S1`` and ``S2``.
	
		.. image:: ../images/heater-ms-drop.png


 8.  Now, drag and drop the ``Heater`` model available under ``UnitOperations``. Name the instance as ``B1``
 
 	    .. image:: ../images/heater-drop.png

 9. Now, drag and drop the ``EnergyStream`` model available under ``Streams``. name the instance as ``E1``.
 
 10. Now double click on ``S1``. Component Parameters window opens. Go to Stream Specifications tab. There are two parameter ``Nc`` and ``C`` for which the values are to be entered. As the value for ``Nc`` and ``C`` are already declared earlier in step 6 while defining the variables, these variables are passed here instead of the values. Repeat this for the other material streams.
	 
	  	.. image:: ../images/heater-in-par.png
	  
 11. Now double click on ``B1``. Component Parameters window opens. Go to Heater Specifications tab and enter the values for parameters as mentioned below:
     
	 - ``Nc`` and ``C`` can be entered same as material stream 
	 - ``Pdel`` represents the pressure drop across the heater. As per the problem statement, enter ``Pdel`` as ``101325``.
	 - ``Eff`` represents the heater efficiency. As per the problem statement, enter ``Eff`` as ``1``.
	   
	   .. image:: ../images/heater-par.png
	 
 12. Switch to text view. Following lines of code will be autogenrated ::
	 
        Simulator.Examples.Heater.MS S1(Nc = Nc, C = C) annotation( ...);
        Simulator.Examples.Heater.MS S2(Nc = Nc, C = C) annotation( ...);
        Simulator.UnitOperations.Heater B1(C = C, Eff = 1, Nc = Nc, Pdel = 101325)  annotation( ...);
        Simulator.Streams.EnergyStream E1 annotation ( ...);
  
 13. Now, connect the streams with unit operations. For this, switch back to Diagram view.
 
     .. image:: ../images/heater-connected.png
 
 14. Switch to text view. Following lines of code will be autogenrated under ``equation`` section :: 
  
        connect(E1.Out, B1.En) annotation( ...);
        connect(B1.Out, S2.In) annotation( ...);
        connect(S1.Out, B1.In) annotation( ...);

 15. Specify the pressure, temperature, component mole fractions and molar flow rate for the inlet material stream ::

        S1.x_pc[1, :] = {0.33, 0.33, 0.34};
        S1.P = 202650;
        S1.T = 320;
        S1.F_p[1] = 100;

 16. Now specify one of the variables mentioned earlier during model explaination to satisfy the degrees of freedom. As per the problem statement, amount of heat added is to be specified. ::

 	  B1.Q = 2000000;
    
 17. This completes the Heater package. Now click on ``Simulate`` button to simulate the ``HeaterSimulation`` model. Switch to Plotting Perspective to view the results.
 
 .. note::
 		 You can also find this package named ``Heater`` in the ``Simulator`` library under ``Examples`` package.

Cooler
--------

The Cooler is used to simulate the cooling process of a material stream.

The cooler model have following connection ports:

 * Two Material Streams: feed and outlet stream
 * One Energy Stream: heat added

Following calculation parameters must be provided to the cooler:

 - Pressure Drop ``Pdel``
 - Efficiency ``Eff``

The above variables have been declared of type parameter Real. 
During simulation, their values can specified directly under Cooler Specifications by double clicking on the cooler model instance.


In addition to the above parameters, any one additional variable from the below list must be provided for the model to simulate successfully:

 - Outlet Temperature ``Tout``
 - Temperature Drop ``Tdel``
 - Heat Removed ``Q``
 - Outlet Stream Vapor Phase Mole Fraction ``xvapout``

These variables are declared of type Real.
During simulation, value of one of these variables need to be defined in the equation section.


Simulating a Cooler
~~~~~~~~~~~~~~~~~~~~~

 1. Create a package named ``Cooler``
 
 2. Create a model named ``MS`` inside ``Heater``. This is to extend ``MaterialStream`` model
 
 3. Extend the model ``MaterialStream`` and necessary property method from ``ThermodynamicPackages`` ::
 
	 extends Simulator.Streams.MaterialStreams;
	 extends Simulator.Files.ThermodynamicPackages.RaoultsLaw;
	 

 4. Create another new model named ``CoolerSimulation``
  
 5. Similar to the ``MaterialStream`` example model, import ``ChemsepDatabase`` and create variables 
    for the compounds which are to be used from ``ChemsepDatabase`` ::
	 
        import data = Simulator.Files.ChemsepDatabase;
        parameter data.Methanol meth;
        parameter data.Ethanol eth;
        parameter data.Water wat;
	 
 6. Define variables for Number of components ``Nc`` and component array ``C``. 
    Also assign the variables created for the compounds to the component array ::
	 
        parameter Integer Nc = 3;
        parameter data.GeneralProperties C[Nc] = {meth, eth, wat};
    
 7. Now, create three instances of the ``MaterialStream`` model ``MS`` as we require one material stream which will 
    go as input and two material streams which will come as output. To do this, open diagram view of ``HeaterSimulation`` model, drag & drop ``MS`` teice as shown in fig. Name the instances as ``S1`` and ``S2``.
	
		.. image:: ../images/cooler-ms-drop.png


 8.  Now, drag and drop the ``Cooler`` model available under ``UnitOperations``. Name the instance as ``B1``
 
 	    .. image:: ../images/cooler-drop.png

 9. Now, drag and drop the ``EnergyStream`` model available under ``Streams``. name the instance as ``E1``.
 
 10. Now double click on ``S1``. Component Parameters window opens. Go to Stream Specifications tab. There are two parameter ``Nc`` and ``C`` for which the values are to be entered. As the value for ``Nc`` and ``C`` are already declared earlier in step 6 while defining the variables, these variables are passed here instead of the values. Repeat this for the other material streams.
	 
	  	.. image:: ../images/cooler-in-par.png
	  
 11. Now double click on ``B1``. Component Parameters window opens. Go to Heater Specifications tab and enter the values for parameters as mentioned below:
     
	 - ``Nc`` and ``C`` can be entered same as material stream 
	 - ``Pdel`` represents the pressure drop across the cooler. As per the problem statement, enter ``Pdel`` as ``0``.
	 - ``Eff`` represents the cooler efficiency. As per the problem statement, enter ``Eff`` as ``1``.
	   
	   .. image:: ../images/cooler-par.png
	 
 12. Switch to text view. Following lines of code will be autogenrated ::
	 
        Simulator.Examples.Heater.MS S1(Nc = Nc, C = C) annotation( ...);
        Simulator.Examples.Heater.MS S2(Nc = Nc, C = C) annotation( ...);
        Simulator.UnitOperations.Cooler B1(Pdel = 0, Eff = 1, Nc = Nc, C = C)  annotation( ...);
        Simulator.Streams.EnergyStream E1 annotation ( ...);
  
 13. Now, connect the streams with unit operations. For this, switch back to Diagram view.
 
     .. image:: ../images/cooler-connected.png
 
 14. Switch to text view. Following lines of code will be autogenrated under ``equation`` section :: 
  
        connect(E1.Out, B1.En) annotation( ...);
        connect(B1.Out, S2.In) annotation( ...);
        connect(S1.Out, B1.In) annotation( ...);

 15. Specify the pressure, temperature, component mole fractions and molar flow rate for the inlet material stream ::

        S1.x_pc[1, :] = {0.33, 0.33, 0.34};
        S1.P = 101325;
        S1.T = 353;
        S1.F_p[1] = 100;

 16. Now specify one of the variables mentioned earlier during model explaination to satisfy the degrees of freedom. As per the problem statement, amount of heat removed is to be specified. ::

 	  B1.Q = 2000000;
    
 17. This completes the Cooler package. Now click on ``Simulate`` button to simulate the ``CoolerSimulation`` model. Switch to Plotting Perspective to view the results.
 
 .. note::
 		 You can also find this package named ``Cooler`` in the ``Simulator`` library under ``Examples`` package.


Heat Exchangers
-----------------


Simulating a Heat Exchanger
~~~~~~~~~~~~~~~~~~~~~~~~~~~~

