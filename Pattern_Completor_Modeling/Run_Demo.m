basepath = pwd;

%set format
format long

% THIRDPARTY DEPENDENCIES
addpath(fullfile(basepath,'thirdparty'))
addpath(fullfile(basepath,'thirdparty','QPBO-v1.32.src'))
addpath(fullfile(basepath,'thirdparty','glmnet_matlab'))
addpath(fullfile(basepath,'thirdparty','glmnet_matlab','glmnet_matlab'))
addpath(fullfile(basepath,'expt'))

% SOURCE FUNCTIONS

addpath(fullfile(basepath,'src_fun'))
addpath(fullfile(basepath,'src_fun','ANALYSIS'))
addpath(fullfile(basepath,'src_fun','FRAMEWORK'))
addpath(fullfile(basepath,'src_fun','MLE_STRUC'))
addpath(fullfile(basepath,'src_fun','include'))
addpath(fullfile(basepath,'src_fun','STRUCTURE'))

addpath(fullfile(basepath,'Hopfield Generation'))
addpath(fullfile(basepath,'Small_Network'))
addpath(fullfile(basepath,'Large_Network'))


prompt = 'Do you want to run a small network or a full-scale simulation? Enter S or L:';
Choice = input(prompt,'s');
if isempty(Choice)
    Choice = 'S';
end

if strcmp(Choice,'S')
    SMALL_TEST;
else
    LARGE_TEST;
end

warning('off','all');
[basepath,params]=start_up();

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%STRUCTURAL LEARNING%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%generate neighborhoods
params.variable_groups = all_but_me(1, size(params.x_train,2), params);

%perform regularization across parameter sequences for each neighborhood
[params]=learn_structures_opt(params);

%calculate structures
for i = 1:params.num_structures
    params.learned_structure{i} = learn_structures(params,params.s_lambda_sequence(i));
end

%feedback
fprintf('\n')
fprintf(strcat(num2str(params.num_structures),' Structures Formed'))
fprintf('\n');

[models] = pre_allocate_models(params);
fprintf(strcat(num2str(numel(models)), ' Models Pre-Allocated for Parameter Estimation'))
fprintf('\n')
fprintf('\n')

save(strcat(params.exptdir, '/', 'structures.mat'), 'models');
save(strcat(params.exptdir, '/', 'model_parameters.mat'),'params');
save('parameters.mat','params');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%PARAMETER ESTIMATION%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Make Parameter Estimation Obect
model_collection = LoopyModelCollection(models,params);

%Clean-up memory
clear models


fprintf('Parameter Estimation...\n');
%Parameter Estimation
        model_collection = model_collection.do_parameter_estimation(...
            params.BCFW_max_iterations, params.BCFW_fval_epsilon,...
            params.compute_true_logZ, params.reweight_denominator,...
            params.printInterval, params.printTest, params.MaxTime);
        
        
%Save Collection & Identify Best Model  
[best_model_index] = get_best_model(model_collection);
[best_model] = SingleLoopyModel(model_collection, best_model_index);
%Convert to Structures
warning('off','all');
model_collection=struct(model_collection);
best_model = struct(best_model);
save(strcat(params.exptdir, '/', 'model_collection.mat'), 'model_collection');
save(strcat(params.exptdir, '/', 'best_model.mat'), 'best_model');

d = fullfile(basepath,'expt','SIM_DATA');
load(strcat(d,'/','model_parameters.mat'));
load(strcat(d,'/','best_model.mat'));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%CORE ANALYSIS%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Analysis for Core neurons//Pattern Completers
[~, results] = find_core_ext_IDs(best_model,params.data,params.UDF);

fprintf('\n')
fprintf('Finding Pattern Completers')
fprintf('\n')

[PCNs, PAPS_INDEXED] = PAPS_score(best_model,results,params);
results.PCNs = PCNs;
results.PAPS_INDEXED = PAPS_INDEXED;
save(strcat(d,'/','results.mat'));

fprintf('\n')
fprintf('Demo Completed')
fprintf('\n')

plot_script;
