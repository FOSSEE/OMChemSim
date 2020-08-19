.. _mixers:

Mixers
=======


Mixer
------

The **Mixer** is used to mix up to any number of material streams into one, 
while executing all the mass and energy balances.

The only calculation parameter for mixer is the outlet pressure calculation mode (outPress) 
variable which is of type parameter String. It can have either of the string values among the 
following modes:
	
 - ``Inlet_Minimum``  Outlet pressure is taken as minimum of all inlet streams pressure
 - ``Inlet_Average``  Outlet pressure is calculated as average of all inlet streams pressure
 - ``Inlet_Maximum``  Outlet pressure is taken as maximum of all inlet streams pressure
	
``outPress`` has been declared of type parameter String. 
During simulation, it can specified directly under Mixer Specifications
by double clicking on the mixer model instance.


Simulating a Mixer
~~~~~~~~~~~~~~~~~~~

 1. Create a package named ``Mixer``
 
 2. Create a model named ``MS`` inside ``Mixer``. This is to extend ``MaterialStream`` model
 
 3. Extend the model ``MaterialStream`` and necessary property method from ``ThermodynamicPackages`` ::
 
	 extends Simulator.Streams.MaterialStreams;
	 extends Simulator.Files.ThermodynamicPackages.RaoultsLaw;
	 

 4. Create another new model named ``MixerSimulation``
  
 5. Similar to the ``MaterialStream`` example model, import ``ChemsepDatabase`` and create variables 
    for the compounds which are to be used from ``ChemsepDatabase`` ::
	 
	 import data = Simulator.Files.ChemsepDatabase;
	 parameter data.Ethanol eth;
	 parameter data.Methanol meth;
	 parameter data.Water wat;
	 
 6. Define variables for Number of components ``Nc`` and component array ``C``. 
    Also assign the variables created for the compounds to the component array ::
	 
     parameter Integer Nc = 3;
     parameter data.GeneralProperties C[Nc] = {meth, eth, wat};
    
 7. Now, create six instances of the ``MaterialStream`` model ``MS`` as we require six material streams which will 
    go as input. To do this, open diagram view of ``MixerSimulation`` model, drag & drop ``MS`` for six times for six input streams as shown in fig. Name the instances as ``S1``, ``S2``, ``S3``, ``S4``, ``S5`` and ``S6``
	
	.. image:: ../images/mixer-ms-in-drop.png
	
 8. Similarly, create amother instance of the ``MaterialStream`` model ``MS`` which will act as the outlet stream. Name the instance as ``S7``
 
 	.. image:: ../images/mixer-ms-out-drop.png
 
 9. Now, Drag and drop the ``Mixer`` model available under ``UnitOperations``. Name the instance as ``B1``
 
 	.. image:: ../images/mixer-drop.png

 10. Now double click on ``S1``. Component Parameters window opens. Go to Stream Specifications tab. There are two parameter ``Nc`` and ``C`` for which the values are to be entered. 
     As the value for ``Nc`` and ``C`` are already declared earlier in step 6 while defining the variables, these variables are passed here instead of the values. Repeat this for remaining five input material streams and the output material stream.
	 
	  	.. image:: ../images/mixer-in-par.png
	  
 11. Now double click on ``B1``. Component Parameters window opens. Go to Mixer Specifications tab and enter the values for parameters as mentioned below:
     
	 - ``Nc`` and ``C`` can be entered same as material stream 
	 - ``NI`` represents the number of input material streams. As there are six material streams going as input, enter 6 against ``NI``
	 - ``outPress`` represents the pressure calculation mode for outlet material stream. Currently mixer support three different 
	   calculation mode which are inlet minimum,inlet average and inlet maximum. Here inlet average will be selected. So enter ``"Inlet_Average"``
	   
	   .. image:: ../images/mixer-par.png
	 
 12. Switch to text view. Following lines of code will be autogenrated ::
	 
	  MS S1(Nc = Nc, C = C) annotation( ...);
	  MS S2(Nc = Nc, C = C) annotation( ...);
	  MS S3(Nc = Nc, C = C) annotation( ...);
	  MS S4(Nc = Nc, C = C) annotation( ...);
	  MS S5(Nc = Nc, C = C) annotation( ...);
	  MS S6(Nc = Nc, C = C) annotation( ...);
	  Simulator.UnitOperations.Mixer B1(Nc = Nc, NI = 6, C = C, outPress = "Inlet_Average") annotation( ...);
	  MS S7(Nc = Nc, C = C) annotation( ...);
  
 13. Now, connect the streams with unit operations. For this, switch back to Diagram view.
 
     .. image:: ../images/mixer-connected.png
 
 14. Switch to text view. Following lines of code will be autogenrated under ``equation`` section :: 
  
		connect(B1.Out, S7.In) annotation( ...);
		connect(S6.Out, B1.In[6]) annotation( ...);
		connect(S5.Out, B1.In[5]) annotation( ...);
		connect(S4.Out, B1.In[4]) annotation( ...);
		connect(S3.Out, B1.In[3]) annotation( ...);
		connect(S2.Out, B1.In[2]) annotation( ...);
		connect(S1.Out, B1.In[1]) annotation( ...);

 15. Specify the value of pressure for all the six inlet material streams ::

	  S1.P = 101325;
	  S2.P = 202650;
	  S3.P = 126523;
	  S4.P = 215365;
	  S5.P = 152365;
	  S6.P = 152568;
    
 16. Specify the value of temperature for all the six inlet material streams ::
 
	  S1.T = 353;
	  S2.T = 353;
	  S3.T = 353;
	  S4.T = 353;
	  S5.T = 353;
	  S6.T = 353;
    
 17. Specify the value of molar flow rate for all the six inlet material streams ::
 
	  S1.F_p[1] = 100;
	  S2.F_p[1] = 100;
	  S3.F_p[1] = 300;
	  S4.F_p[1] = 500;
	  S5.F_p[1] = 400;
	  S6.F_p[1] = 200;
	  
 18. Specify the mole fraction of components for all the six inlet material streams ::
 
	  S1.x_pc[1, :] = {0.25, 0.25, 0.5};
	  S2.x_pc[1, :] = {0, 0, 1};
	  S3.x_pc[1, :] = {0.3, 0.3, 0.4};
	  S4.x_pc[1, :] = {0.25, 0.25, 0.5};
	  S5.x_pc[1, :] = {0.2, 0.4, 0.4};
	  S6.x_pc[1, :] = {0, 1, 0};

 19. This completes the Mixer package. Now click on ``Simulate`` button to simulate the ``MixerSimulation`` model. Switch to Plotting Perspective to view the results.
 
 .. note::
 		 You can also find this package named ``Mixer`` in the ``Simulator`` library under ``Examples`` package.




Splitter
---------

The Splitter is used to split up to a material streams into two, while executing all the 
mass and energy balances.


The only calculation parameter for splitter is the calculation type ``CalcType`` variable 
which is of type parameter String. It can have either of the string values among the following types:
 - ``Split_Ratio`` Mass and molar flow rate of the outlet streams are to be calculated depending on the specified split ratio
 - ``Mass_Flow`` Molar flow rate of the outlet streams are to be calculated depending on the specified mass flow rates of outlet stream
 - ``Molar_Flow`` Mass flow rate of the outlet streams are to be calculated depending on the specified molar flow rate of the outlet stream

``CalcType`` has been declared of type parameter String. 
During simulation, it can specified directly under Splitter Specifications by double clicking 
on the splitter model instance.


Depending on the CalcType specified in the Splitter Specification, its value has to be specified 
through the variable Specification Value ``SpecVal_s``. It is declared of type Real.
During simulation, value of this variable need to be defined in the equation section.


Simulating a Splitter
~~~~~~~~~~~~~~~~~~~~~~

 1. Create a package named ``Splitter``
 
 2. Create a model named ``MS`` inside ``Splitter``. This is to extend ``MaterialStream`` model
 
 3. Extend the model ``MaterialStream`` and necessary property method from ``ThermodynamicPackages`` ::
 
	 extends Simulator.Streams.MaterialStreams;
	 extends Simulator.Files.ThermodynamicPackages.RaoultsLaw;
	 

 4. Create another new model named ``SplitterSimulation``
  
 5. Similar to the ``MaterialStream`` example model, import ``ChemsepDatabase`` and create variables 
    for the compounds which are to be used from ``ChemsepDatabase`` ::
	 
	 import data = Simulator.Files.ChemsepDatabase;
	 parameter data.Benzene benz;
	 parameter data.Toluene tol;
	 
 6. Define variables for Number of components ``Nc`` and component array ``C``. 
    Also assign the variables created for the compounds to the component array ::
	 
     parameter Integer Nc = 2;
     parameter data.GeneralProperties C[Nc] = {benz, tol};
    
 7. Now, create three instances of the ``MaterialStream`` model ``MS`` as we require one material stream which will 
    go as input and two material streams which will come as output. To do this, open diagram view of ``SplitterSimulation`` model, drag & drop ``MS`` for three times as shown in fig. Name the instances as ``S1``, ``S2`` and ``S3``
	
		.. image:: ../images/splitter-ms-drop.png


 8.  Now, Drag and drop the ``Splitter`` model available under ``UnitOperations``. Name the instance as ``B1``
 
 	    .. image:: ../images/splitter-drop.png

 9. Now double click on ``S1``. Component Parameters window opens. Go to Stream Specifications tab. There are two parameter ``Nc`` and ``C`` for which the values are to be entered. As the value for ``Nc`` and ``C`` are already declared earlier in step 6 while defining the variables, these variables are passed here instead of the values. Repeat this for remaining two material streams.
	 
	  	.. image:: ../images/splitter-in-par.png
	  
 10. Now double click on ``B1``. Component Parameters window opens. Go to Splitter Specifications tab and enter the values for parameters as mentioned below:
     
	 - ``Nc`` and ``C`` can be entered same as material stream 
	 - ``No`` represents the number of output material streams. As we have two material streams coming out, enter 2 against ``No``
	 - ``CalcType`` represents the calculation type specification for outlet material stream. Currently splitter support three different 
	   calculation type which are split ratio,mass flow and molar flow. Here molar flow will be selected. 
	   So enter ``"Molar_Flow"``
	   
	   .. image:: ../images/splitter-par.png
	 
 11. Switch to text view. Following lines of code will be autogenrated ::
	 
	  MS S1(Nc = Nc, C = C) annotation( ...);
	  MS S2(Nc = Nc, C = C) annotation( ...);
	  MS S3(Nc = Nc, C = C) annotation( ...);
	  Simulator.UnitOperations.Splitter B1(Nc = Nc, No = 6, C = C, CalcType = "Molar_Flow") annotation( ...);
  
 12. Now, connect the streams with unit operations. For this, switch back to Diagram view.
 
     .. image:: ../images/splitter-connected.png
 
 13. Switch to text view. Following lines of code will be autogenrated under ``equation`` section :: 
  
		connect(B1.Out[2], S3.In) annotation( ...);
		connect(B1.Out[1], S2.In) annotation( ...);
		connect(S1.Out, B1.In) annotation( ...);

 14. Specify the pressure, temperature, component mole fractions and molar flow rate for the inlet material stream ::

	  S1.P = 101325;
  	  S1.T = 300;
  	  S1.x_pc[1, :] = {0.5, 0.5};
  	  S1.F_p[1] = 100;

 15. Now specify the specification value for the selected calculation type in splitter ::

 	  B1.SpecVal_s = {20, 80};
    
 16. This completes the Splitter package. Now click on ``Simulate`` button to simulate the ``SplitterSimulation`` model. Switch to Plotting Perspective to view the results.
 
 .. note::
 		 You can also find this package named ``Splitter`` in the ``Simulator`` library under ``Examples`` package.