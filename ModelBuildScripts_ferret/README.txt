Usage notes for the cortical slice model described in Tomsett et al. 2014.

The parameter files for the model described by Tomsett et al. (2014)
are included in the main VERTEX download (in the bsfModel folder), and
are also available on figshare. The parameters are set to run the full
model as described in the paper, using VERTEX in parallel mode with 12
labs, to run the simulation for 2400 ms. To run the model, first make
sure you have added the VERTEX simulator to your Matlab path as
described in Tutorial 0 at vertexsimulator.org. You should also
compile the MEX file as described in that tutorial to allow more than
one connection from a presynaptic to a postsynaptic neuron. then run
the script bsf_model_run.m - this will load the parameters from the
other .m files, initialise the network, and run the simulation. You
can modify parameters either in the other parameter files, or in the
bsf_model_run.m file (for example, if you want to change the number of
labs or the location to save results). Results can then be loaded and
analysed as described in the tutorials.

NB: the results will be qualitatively, but not quantitatively, the
same as in the paper, because the random number generator control code
was not implemented at that time.

The model contains approximately 175,000 neurons, each with several
compartments, so the memory requirements are quite large. Including
the overheads for running on 12 Matlab workers, the simulation uses
about 30 GB RAM on our Intel Xeon based Linux server (Matlab 2012b).

We have also uploaded the raw experimental data used for comparison in
figure 9 of the paper, along with a script to generate a similar gamma
power map to that shown in figure 9a. The data can be downloaded from
figshare (link below).

If you have any trouble running the simulation or want further details
on either the simulation or the experimental data, please contact us
using the contact form.

Figshare link: http://autap.se/figshare

Reference:

Tomsett RJ, Ainsworth M, Thiele A, Sanayei M, Chen X, Gieselmann MA,
Whittington MA, Cunningham MO, Kaiser M. (2014) Virtual Electrode
Recording Tool for EXtracellular potentials (VERTEX): comparing
multi-electrode recordings from simulated and biological mammalian
cortical tissue, Brain Structure and
Function. doi:10.1007/s00429-014-0793-x
