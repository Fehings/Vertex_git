%% Heun.m
% Heun integrator for SDE in Stratonovich form. 

% References: 
% Aburn, Holmes, Roberts, Boonstra and Breakspear (2012) "Critical Fluctuations in 
%    Cortical Models Near Instability", Front. Physio. 3:331. doi:10.3389/fphys.2012.00331
% Mannella, R (2002) Integration of Stochastic Differential Equations on a Computer
% Rumelin, W (1982) Numerical Treatment of Stochastic Differential Equations

% Copyright 2012 Matthew J. Aburn
% 
% This program is free software: you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.
% 
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
% 
% You should have received a copy of the GNU General Public License
% along with this program.  If not, see <http://www.gnu.org/licenses/>.


% Arguments:
% f, g      Function handles defining the RHS of Stratonovich SODE system: dy = f(t,y).dt + g(t,y).dW
% tspan     Vector of fixed-size time steps for integration: [0:0.01:5] 
% y0        Vector of initial conditions
%
% Example:
% see JansenSingle.m
%
function sol = Heunmod_vertex(f, g, tspan, y0, VERTEX,p)
%Heun solver but modified to have pregend noise and to add stimuli
%through the external noise input.
    % get dimension of system
    n = size(y0,1);
    d = size(y0,2); %length of delays
    steps = numel(tspan) - 1; 
    
    if VERTEX.region == 1
        Vreg=1;
    else
        Vreg=6*VERTEX.region;
    end
    %rng(1)             %
    rn=randn(n,steps+d); %pregen noise vector
    %rn(5,ceil(steps/3):ceil(steps/3)+1000)=100;%rn(5,ceil(steps/3))*100; %Add a boosted stimulation at a certain time point 
    % validate some arguments
    %if numel(g(tspan(1),y0))~=n || numel(f(tspan(1),y0))~=n
    %    ex = MException('Heun:InvalidArgs', 'Argument dimensions are inconsistent');
    %    throw(ex);
    %end
    % create array to hold results
    sol.y = [y0, zeros(n, steps-d+1)];
    sol.x = tspan;
    sol.solver = 'Heun';
    % integrate
    for k = d+1:(steps-d+1)
        
        %janrit step stim
        if tspan(k) > p.stepstimon && tspan(k) < p.stepstimoff
            p.v_stim = p.stepstimstrength;
        elseif tspan(k) > p.stepstimoff
            p.v_stim = 0;
        end
        
        tn = tspan(k-1);
        tm = tspan(k);
        yn = sol.y(:,k-d:k-1);
        dt = tm - tn;
        dW = sqrt(dt).*rn(:,k-1);%Weiner(dt,k-1);
        ybar = [yn(:,1:end-1),(yn(:,end) + f(tn, yn,p).*dt + g(tn, yn,p).*dW)];
        sol.y(:, k) = yn(:,end) + 0.5.*(f(tn, yn,p) + f(tm, ybar,p)).*dt + 0.5.*(g(tn, yn,p) + g(tm, ybar,p)).*dW;  
        %The connections from to and from the VERTEX region can be updated in the
        %janrit part, but then these updates also need to be passed to the
        %VERTEX model proper so it takes them into account when calculating
        %the next step.
%         disp('Janrit solution')
%         sol.y(:,k)
        
        yn_mat= reshape(yn,[6,p.num_nodes,p.max_delay]);
        output=sigm(squeeze(yn_mat(2,:,:)-yn_mat(3,:,:)));
        if p.delay==0
            output=output';
        end
        delayed_out=repmat(output,p.num_nodes,1).*p.delayconn;%[vector here of times to access for each node]);
        delayed_out=sum(delayed_out,2);
        delayed_out=sum(reshape(delayed_out,p.num_nodes,p.num_nodes));
        for iGroup = 1:VERTEX.TP.numGroups
        
            getExternalInput(VERTEX.IMA{iGroup,2},delayed_out);  
        
        end
        % update an input model here for the passed in connections
        %update the vertex region for one time step
        [VERTEX.NMA,VERTEX.SMA,VERTEX.IMA,VERTEX.iterator,VERTEX.S,VERTEX.RecVar,VERTEX.wArr] = simulateMultiregional(...
            VERTEX.TP,VERTEX.NP,VERTEX.SS,VERTEX.RS,VERTEX.S,VERTEX.iterator,VERTEX.simStep,...
            VERTEX.revSynArr,VERTEX.IDMap,VERTEX.NMA,VERTEX.SMA,VERTEX.IMA,VERTEX.RecVar,VERTEX.neuronInGroup,...
            VERTEX.lineSourceModCell,VERTEX.synArr,VERTEX.wArr,VERTEX.synMap,1);
        %overwriting the current status info for the VERTEX region with the
        %VERTEX solution.
        sol.y(Vreg:Vreg+6,k) = sol.y(Vreg:Vreg+6,k)*0; % zero the values for the VERTEX region
        sol.y(Vreg+1,k) = (VERTEX.S.currentgroupspikes{1});%mean(mean(VERTEX.RecVar.LFPRecording{1}(:,:,end))) 
        % give the group PY spikes y2 value for the VERTEX region, as
        % y2-y3 is the output used in the JanRit model.
        VERTEX.simStep=VERTEX.simStep+1;
%         disp('with vertex replacement:')

    end
    
    % [NeuronModel, SynModel, InModel, iterator,S,RecVar,wArr] = 
% simulateMultiregional(TP, NP, SS, RS, S, iterator, simStep, revSynArr, IDMap, ...
%    NeuronModel, SynModel, InModel, RecVar, neuronInGroup, 
%lineSourceModCell, synArr, wArr, synMap,rgn)

    % Return n independent random Weiner increments for a time increment of length h 
    %function deltaW = Weiner(h,t)
    %    deltaW = sqrt(h).*rn(:,t); % correctly scale noise
    %end
    %if isfield(VERTEX.RS,'LFPoffline') && VERTEX.RS.LFPoffline
    lineSourceModCell = VERTEX.lineSourceModCell;
save([VERTEX.RS.saveDir 'LineSourceConsts.mat'], 'lineSourceModCell');
    %end


% Store the parameters in the same folder, so we can reference them later
% during analysis (used by loadResults, as well as useful for tracking
% simulations). You may want to copy these lines to store each parameter
% set after every time you call simulate()/simulateParallel().
parameterCell = {VERTEX.TP, VERTEX.NP, VERTEX.CP, VERTEX.RS, VERTEX.SS,VERTEX.SMA};
fname = [VERTEX.RS.saveDir 'parameters.mat'];
save(fname, 'parameterCell','-v7.3');

end
