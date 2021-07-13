clear all
close all
clc

%--------------------------------------------------------------------------
options.ObjFunction=@Binh;
options.ll=[-5 -5];% lower bounds
options.ul=[10 10]; % upper bounds
options.clsize=100; % Size of the population
options.nArchive=50;  % Archive Size of the Pareto front
options.Nobj=2; % number of Objective Functions
options.var_num=size(options.ll,2); % dimension of the problem.
options.iteration=100; % Maximum number of iterations
%--------------------------------------------------------------------------
options.Display_Flag=1; % Flag for displaying results over iterations
options.run_parallel_index=0;
options.run=1;

tic
if options.run_parallel_index
    stream = RandStream('mrg32k3a');
    parfor index=1:options.run
        %         index
        set(stream,'Substream',index);
        RandStream.setGlobalStream(stream)
        [bestX, bestFitness, bestFitnessEvolution]=MOJAYA_v1(options);
        RESULTS{index}.bestX=bestX;
        RESULTS{index}.bestFitness=bestFitness;
        RESULTS{index}.bestFitnessEvolution=bestFitnessEvolution;
    end
else
    rng('default')
    for index=1:options.run
        %         index
        [bestX, bestFitness, bestFitnessEvolution]=MOJAYA_v1(options);       
        RESULTS{index}.bestX=bestX;
        RESULTS{index}.bestFitness=bestFitness;
        RESULTS{index}.bestFitnessEvolution=bestFitnessEvolution;
    end
end
toc