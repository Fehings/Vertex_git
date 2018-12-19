# Vertex 2.0
A version of VERTEX that includes synaptic plasticity and electric field stimulation options. 

To explore these options try out the tutorial_5_TBSStimulation and tutorial_5_PPstimulation.

The code to setup and run the rat neocortex model from the paper:
"The Virtual Electrode Recording Tool for EXtracellular Potentials (VERTEX) Version 2.0: 
Modelling \emph{in vitro} electrical stimulation of brain tissue"
can be found in the ratSomatosensoryCortex directory. 

The simulation results used in this paper can be found at 10.5281/zenodo.2423857

To reproduce the figures, download these results then point the generatePaperFigures script to them. 

To run the simulations themselves you can run the singlePulse.m script to run a 
simulation with a single pulse, pairedPulse.m to run a script with a paired of pulses (you will need to modify this
for different pulse intervals), and thetaburststimulation.m to run the simulation with TBS (this simulation
will also have STDP applied at synapses).

All three scripts do the same things - set up the model (same model for each), set up the stimulation (different stimulation times, 
but same model), and set up the run parameters (the variables to record, length of simulation etc.)
There are three runRatSimulation files that correspond to each stimulation paradigm. They specify the 
variables we with to record from the stimulation and the simulation duration, time step etc. 

Running these models at full density will require significant computational and memory resources (we used 12 cores and 200 GB RAM). 
If you wish to run these on a desktop computer then we suggest reducing the neuron density by a factor of ten. 


