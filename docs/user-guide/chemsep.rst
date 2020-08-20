.. _chemsep:

Chemsep Database
================

Chemsep Databse is a library which hosts all the components of Chemsep Database along with their thermophysical properties 
to be used directly in Modelica language.
There are 34 thermophysical properties which are available for the components listed under Chemsep Database.

All these thermophysical properties are defined as variables in the ``GeneralProperties`` model available under
the package ``ChemsepDatabase``. 

General Properties
~~~~~~~~~~~~~~~~~~~~

``GeneralProperties`` model has been created to define the variables for all the thermophysical properties that are available for the
components in Chemsep Database. These variables are to be remain constant during the course of simulation
and therefore the keyword ``parameter`` is prefixed while defining the variables.

In this model, variables for the following constant thermophysical properties are defined:

+------------------+------------------------------------------------+----------------+
|     Variables    |                Description                     |Units           |
+==================+================================================+================+
|SN                |Serial Number                                   |Not Applicable  |
+------------------+------------------------------------------------+----------------+
|name              |Name of the Compound                            |Not Applicable  |
+------------------+------------------------------------------------+----------------+
|CAS               |CAS ID                                          |Not Applicable  |
+------------------+------------------------------------------------+----------------+
|Tc                |Critical Temperature                            |K               |
+------------------+------------------------------------------------+----------------+
|Pc                |Critical Pressure                               |Pa              |
+------------------+------------------------------------------------+----------------+
|Vc                |Critical Volume                                 |m3/kmol         |
+------------------+------------------------------------------------+----------------+
|Cc                |Critical Compressibility Factor                 |No units        |
+------------------+------------------------------------------------+----------------+
|Tb                |Boiling Point Temperature                       |K               |
+------------------+------------------------------------------------+----------------+
|Tm                |Melting Point Temperature                       |K               |
+------------------+------------------------------------------------+----------------+
|TT                |Triple Point Temperature                        |K               |
+------------------+------------------------------------------------+----------------+
|TP                |Triple Point Pressure                           |Pa              |
+------------------+------------------------------------------------+----------------+
|MW                |Molecular Weight                                |kg/kmol         |
+------------------+------------------------------------------------+----------------+
|LVB               |Liquid Molar Volume at Normal Boiling Point     |m3/kmol         |
+------------------+------------------------------------------------+----------------+
|AF                |Accentric Factor                                |No units        |
+------------------+------------------------------------------------+----------------+
|SP                |Solubility Parameter                            |J0.5/m1.5       |
+------------------+------------------------------------------------+----------------+
|DM                |Dipole Moment                                   |Columb.m        |
+------------------+------------------------------------------------+----------------+
|SH                |Absolute Enthalpy                               |J/kmol          |
+------------------+------------------------------------------------+----------------+
|IGHF              |Standard Heat of Formation                      |J/kmol          |
+------------------+------------------------------------------------+----------------+
|AS                |Absolute Entropy                                |J/[kmol.K]      |
+------------------+------------------------------------------------+----------------+
|HFMP              |Heat of Fusion at Melting Point                 |J/kmol          |
+------------------+------------------------------------------------+----------------+
|HOC               |Heat of Combustion                              |J/kmol          |
+------------------+------------------------------------------------+----------------+
|UniquacR          |UNIQUAC R                                       |No Units        |
+------------------+------------------------------------------------+----------------+
|UniquacQ          |UNIQUAC Q                                       |No Units        |
+------------------+------------------------------------------------+----------------+
|Racketparam       |Racket parameter                                |No Units        |
+------------------+------------------------------------------------+----------------+
|ChaoSeadAF        |Chao-Seader Accentric Factor                    |No Units        |
+------------------+------------------------------------------------+----------------+
|ChaoSeadSP        |Chao-Seader Solubility Parameter                |J0.5/m1.5       |
+------------------+------------------------------------------------+----------------+
|ChaoSeadLV        |Chao-Seader Liquid Volume                       |m3/kmol         |
+------------------+------------------------------------------------+----------------+


Aditionally, array variables for the following temperature dependent properties are also defined.

+------------------+------------------------------------------------+----------------+
|     Variables    |                Description                     |Units           |
+==================+================================================+================+
|LiqDen[6]         |Liquid Density Coefficients                     |kmol/m3         |
+------------------+------------------------------------------------+----------------+
|VP[6]             |Vapor Pressure Coefficients                     |Pa              |
+------------------+------------------------------------------------+----------------+
|LiqCp[6]          |Liquid Heat Capacity Coefficients               |J/[kmol.K]      |
+------------------+------------------------------------------------+----------------+
|HOV[6]            |Heat of Vaporization Coefficients               |J/kmol          |
+------------------+------------------------------------------------+----------------+
|VapCp[6]          |Ideal Gas Heat Capacity Coefficients            |J/[kmol.K]      |
+------------------+------------------------------------------------+----------------+
|LiqVis[6]         |Liquid Viscosity Coefficients                   |Pa s            |
+------------------+------------------------------------------------+----------------+
|VapVis[6]         |Vapor Viscosity Coefficients                    |Pa s            |
+------------------+------------------------------------------------+----------------+
|LiqK[6]           |Liquid Thermal Conductivity Coefficients        |W/[m.K]         |
+------------------+------------------------------------------------+----------------+
|VapK[6]           |Vapor Thermal Conductivity Coefficients         |W/[m.K]         |
+------------------+------------------------------------------------+----------------+

The first indice of the array refers to the equation number from the Chemsep Database 
which is used to calculate the property value as function of temperature. Remaining 
indices are the actual coefficients that are used in the equation to calculate the property.

Every component of Chemsep Database is a separate model where the ``GeneralProperties`` model is then extended 
and then the property values are passed for the corresponding parameter variables.

For example, to define the thermophysical properties of component **Air**, the model ``Air`` is created as ::
 
		model Air
		...
		extends GeneralProperties(SN = 1, name = "Air", CAS = "132259-10-0", Tc = 132.45, ...");
		end Air;
		
While creating any unit operation model, ``GeneralProperties`` model of ``ChemsepDatabase`` must be instantiated so that
the thermophysical properties of the components can be used and accessed by the unit operation model while using it during
the course of simulation. This can be done by writing
the below line of code ::

		parameter Simulator.Files.ChemsepDatabase.GeneralProperties C[Nc];
		
Here, ``C[Nc]`` is an array variable which can be used to access all the thermophysical properties available in ``GeneralProperties`` model
of ``ChemsepDatabase``.
		
Using Components from Chemsep Database in a Simulation
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Following are the steps that must be followed to use any component from ``ChemsepDatabase`` while creating a simulation:

1. First, ``ChemsepDatabase`` has to be imported and stored it in a variable.
Here, it is stored in a variable called ``data``. This can be done by writing the following line of code ::

		import data = Simulator.Files.ChemsepDatabase;
		
2. Once the database is imported and stored in the variable ``data``, then it can be called to create instances for the
components required in the simulation. For example, if Methanol and Ethanol are the compounds to be used in the simulaation,
its instances can be created by writing the following lines of codes ::

		parameter data.Methanol meth;
		parameter data.Ethanol eth;
		
Here, ``meth`` and ``eth`` are the instances created from the compound Methanol and Ethanol respectively.

3. Next step is to declare an integer variable to define the number of components to be used in the simulation. Here,
varibale ``Nc`` is used to define the number of variables ::
 
		parameter Interger Nc = 2;

4. Next step is to declare an array variable of size equal to number of components ``Nc`` and assign the general properties of the 
component instances created in step 2 to the array. Here, ``C`` is the array variable declared. 
This can be done by writing the following lines of code ::

	  parameter data.GeneralProperties C[Nc] = {meth, eth};
		
