function [params, connections, electrodes] = ...
  initNetwork(TP, NP, CP, RS, SS, control)
%INITNETWORK Initialise simulation environment, setup the network and calculate constants for extracellular potential simulation.
%
%   [PARAMS, CONNECTIONS, ELECTRODES] = INITNETWORK(TP, NP, CP, RS, SS)
%   sets up the simulation environment according to the simulation settings
%   in the SS structure (including initialising the parallel environment if
%   specified), sets up the neuron groups and positions the neurons in the
%   model space according to the tissue parameters in the TP structure and
%   neuron group parameters in the NP structure array, connects the neurons
%   together into a network according to the connectivity parameters in the
%   CP structure array, and calculates the constants used in the extracellular
%   potential calculation (if the extracellular potential is being
%   simulated). PARAMS is a structure with fields TissueParams,
%   NeuronParams, ConnectionParams, RecordingSettings and
%   SimulationSettings, that will be passed to the runSimulation() function.
%   In serial mode, CONNECTIONS is an N by 3 cell array containing connectivity
%   information, where N is the total number of neurons. The first column
%   of the cell array contains lists of postsynaptic neuron IDs for each
%   presynaptic neuron. The second column contains the corresponding
%   postsynaptic compartment IDs, and the third column contains the
%   corresponding axonal conduction delays, specified in number of
%   simulation timesteps. In parallel mode, CONNECTIONS is a composite
%   containing the connection cell array for the neurons in each lab.
%   In serial mode, ELECTRODES contains an N by E cell array with the
%   constants used in the extracellular potential calculation for each
%   neuron compartment and each electrode in the model. N is the total
%   number of neurons in the model, and E is the number of extracellular
%   electrodes. Each cell contains an array with the relevant constant for
%   each compartment in that neuron for that electrode. In parallel mode,
%   ELECTRODES is a composite containing the electrode cell array for the
%   neurons in each lab. PARAMS, CONNECTIONS and ELECTRODES can then be
%   used as inputs to the runSimulation() function.
%
%   [PARAMS, CONNECTIONS, ELECTRODES] = INITNETWORK(TP, NP, CP, RS, SS, CONTROL)
%   allows you to specify how far through the network initialisation
%   process you want INITNETWORK to go. CONTROL is a structure with three
%   possible, optional fields (if any is omitted, its default value is
%   true).
%   - CONTROL.init is a logical (boolean) value specifying whether to run
%   the initialising functions to setup the simulation environment and
%   position the neurons
%   - CONTROL.connect is a logical (boolean) value specifying whether to
%   generate the connectivity
%   - CONTROL.LFPconsts is a logical (boolean) value specifying whether to
%   generate the LFP simulation constants
%   If CONTROL.connect is false, CONNECTIONS will be returned as an empty
%   cell array. If CONTROL.LFPconsts is false, ELECTRODES will be returned
%   as an empty cell array.

if nargin == 6
  if ~isfield(control, 'init')
    control.init = true;
  end
  if ~isfield(control, 'stim')
      if isfield(TP, 'StimulationField')
        control.stim = true;
      else
          control.stim = false;   
      end
  end
  if ~isfield(control, 'connect')
    control.connect = true;
  end
  if ~isfield(control, 'LFPconsts')
    control.LFPconsts = true;
  end
else
  control.init = true;
  control.connect = true;
  control.LFPconsts = true;
      if isfield(TP, 'StimulationField')
        control.stim = true;
      else
          control.stim = false;
      end
end

if ~isfield(SS,'onTopsy')
    SS.onTopsy = 0;
end

% Convert Maps to structs if necessary
if isNewMatlab()
  TP = vertexMapToStruct(TP);
  NP = vertexMapToStruct(NP, true);
  CP = vertexMapToStruct(CP);
  RS = vertexMapToStruct(RS);
  SS = vertexMapToStruct(SS);
end

% Check the parameter structures for errors
TP = checkTissueStruct(TP);
NP = checkNeuronStruct(NP);
CP = checkConnectivityStruct(CP);
RS = checkRecordingStruct(RS);
SS = checkSimulationStruct(SS);



adjustedcompartments = false;
for iGroup = 1:length(NP)
    if isfield(NP(iGroup), 'minCompartmentSize')
        adjustedcompartments = true;
        % Adjusts the number and size of compartments to ensure that the
        % electric field calculations remain valid. Caution should be advised
        % that this can drastically increase the size of the simulation.
        if ~isempty(NP(iGroup).minCompartmentSize)
            Nparams(iGroup) = adjustCompartments(NP(iGroup), TP);
           
        else
            NP(iGroup).minCompartmentSize = Inf;
            Nparams(iGroup) = adjustCompartments(NP(iGroup), TP);
        end
    end
end

if adjustedcompartments
    NP = Nparams;
end

for iGroup = 1:length(NP)
    for iTC = 1:length(CP(iGroup).targetCompartments)
        
        if iscellstr(CP(iGroup).targetCompartments{iTC}) || isstring(CP(iGroup).targetCompartments{iTC}) || ischar(CP(iGroup).targetCompartments{iTC})
            locations = [];
            for iLoc = 1:length(CP(iGroup).targetCompartments{iTC})
                
                if iscell(CP(iGroup).targetCompartments(iTC))
                    location = CP(iGroup).targetCompartments{iTC}{iLoc};
                else
                    location = CP(iGroup).targetCompartments{iTC}(Loc);
                end
                locations = [locations NP(iTC).(location)];
            end
            CP(iGroup).targetCompartments{iTC} = unique(locations);
        elseif ~isempty(CP(iGroup).targetCompartments{iTC})
            if adjustedcompartments
                disp(['For Neuron group: ' num2str(iGroup) ' connecting to : ' num2str(iTC)] ); 
                disp('You have specified synapse locations manually but selected to automatically adjust compartment numbers.')
                disp('When adjusting compartments automatically, you should specify the synapse locations as a string.');
                disp('Are you sure you wish to procede?')
            end
        end
    end
end


if control.init
  % Calculate sampling constants
  [RS, SS] = setupSamplingConstants(RS, SS);
  
  % Setup parallel simulation environment, if necessary
  SS = setupEnvironment(SS);
  setRandomSeed(SS);
  
  % Check if multiSyn.cpp has been compiled and set SS.multiSyn accordingly
  multiSyn = exist(['multiSynapse.' mexext()], 'file');
  SS.multiSyn = multiSyn == 3;
  
  % Calculate number of neurons and set group boundaries
  [SS, TP, NP] = setupGroupBounds(NP, SS, TP);
  
  % Setup the "strip" boundaries
  TP = setupStripBounds(TP);
  
  % Position neurons
  TP = positionNeurons(NP, TP);
  
  % if recording variables are specified spatially, set up recording IDs
  % now
  if isfield(RS, 'I_syn_location')
      RS.I_syn = [];
      for i = 1:length(RS.I_syn_number)
        RS.I_syn = [RS.I_syn getNeuronsNear(TP, RS.I_syn_location(i,:), RS.I_syn_number(i), RS.I_syn_group(i))'];
      end
  end
  if isfield(RS, 'v_m_location')
      RS.v_m = [];
      for i = 1:length(RS.v_m_number)
        RS.v_m = [RS.v_m getNeuronsNear(TP, RS.v_m_location(i,:), RS.v_m_number(i), RS.v_m_group(i))'];
      end
  end
  if isfield(RS, 'stp_syn_location')
      RS.stp_syn = [];
      for i = 1:length(RS.stp_syn_number)
        RS.stp_syn = [RS.stp_syn getNeuronsNear(TP, RS.stp_syn_location(i,:), RS.stp_syn_number(i), RS.stp_syn_group(i))'];
      end
  end
  if isfield(RS, 'stdpvars_location')
      RS.stdpvars = [];
      for i = 1:length(RS.stdpvars_number)
        RS.stdpvars = [RS.stdpvars getNeuronsNear(TP, RS.stdpvars_location(i,:), RS.stdpvars_number(i), RS.stdpvars_group(i))'];
      end
  end
  if isfield(RS, 'weights_preN_IDs_location')
      RS.weights_preN_IDs = [];
      for i = 1:length(RS.weights_preN_IDs_number)
        RS.weights_preN_IDs = [RS.weights_preN_IDs getNeuronsNear(TP, RS.weights_preN_IDs_location(i,:), RS.weights_preN_IDs_number(i), RS.weights_preN_IDs_group(i))'];
      end
  end
  if isfield(RS, 'CSD_groups')
      RS.CSD_NeuronIDs = [];
      for i = 1:length(RS.CSD_groups)
        RS.CSD_NeuronIDs{i} = getNeuronsBetween(TP, RS.CSD_groups(i), RS.CSD_Xboundary(i,:), RS.CSD_Yboundary(i,:), RS.CSD_Zboundary(i,:));
      end
      RS.CSD = true;
  end
  if isfield(RS, 'I_synComp_groups')
      if ~isfield(RS, 'I_synComp_NeuronIDs')
          if isfield(RS, 'I_synComp_Xboundary')
              RS.I_synComp_NeuronIDs = [];
              for i = 1:length(RS.I_synComp_groups)
                  RS.I_synComp_NeuronIDs{i} = getNeuronsBetween(TP, RS.I_synComp_groups(i), RS.I_synComp_Xboundary(i,:), RS.I_synComp_Yboundary(i,:), RS.I_synComp_Zboundary(i,:));
              end
          elseif isfield(RS, 'I_synComp_location')
              RS.I_synComp_NeuronIDs = [];
              for i = 1:length(RS.I_synComp_groups)
                  RS.I_synComp_NeuronIDs{i} = getNeuronsNear(TP, RS.I_synComp_location(i,:), RS.I_synComp_number(i), RS.I_synComp_groups(i));
              end
          end
      end
      RS.I_synComp = true;
  end
  % Calculate compartment connectivity probabilities according to positions
  % in layers
  NP = calculateCompartmentConnectionProbabilities(NP, TP);
  
  % Distribute neurons among parallel processes if this is a parallel sim
  if SS.parallelSim
    [SS, TP] = distributeNeurons(SS, TP);
  end
end

if control.connect
  % Generate the connectivity
  [connections, SS] = modelConnect(CP, NP, SS, TP);
else
  connections = {};
end
% If recording the LFP, pre-calculate line-source constants
if control.LFPconsts
  if RS.LFP
    disp('Pre-calculating LFP simulation constants...')
    [TP.compartmentlocations, electrodes] = setupLFPConstants(NP, RS, SS, TP);
  else
    electrodes = {};
  end
else
  electrodes = {};

end
if control.stim
    if isfield(TP, 'StimulationField')
        disp('Finding compartment locations...')
        if SS.parallelSim
            spmd
                compartmentlocations = getCompartmentLocations(NP,SS,TP);
            end
            TP.compartmentlocations = compartmentlocations;
        else
            TP.compartmentlocations = getCompartmentLocations(NP,SS,TP);
        end
    end
end

% Store the parameters in a single params structure
params.TissueParams = TP;
params.NeuronParams = NP;
params.ConnectionParams = CP;
params.RecordingSettings = RS;
params.SimulationSettings = SS;
disp('Model successfully initialised!');


