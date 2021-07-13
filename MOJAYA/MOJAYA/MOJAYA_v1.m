function [bestX, bestFitness, Archive] = MOJAYA_v1(options)
%--------------------------------------------------------------------------
% Black Hole Algorithm
% Dr Hpussem BOUCHEKARA
% 20/07/2019
%--------------------------------------------------------------------------
% 1. Bouchekara, H. R. E. H. (2013). Optimal design of electromagnetic
% devices using a black-Hole-Based optimization technique. IEEE
% Transactions on Magnetics, 49(12). doi:10.1109/TMAG.2013.2277694
%
% 2. Bouchekara, H. R. E. H. (2014). Optimal power flow using black-hole-based
% optimization approach. Applied Soft Computing, 24, 879–888.
% doi:10.1016/j.asoc.2014.08.056
%
% 3. Smail, M. K., Bouchekara, H. R. E. H., Pichon, L., Boudjefdjouf, H.,
% Amloune, A., & Lacheheb, Z. (2016). Non-destructive diagnosis of wiring
% networks using time domain reflectometry and an improved black hole
% algorithm. Nondestructive Testing and Evaluation.
% doi:10.1080/10589759.2016.1200576
%--------------------------------------------------------------------------
ObjFunction=options.ObjFunction; % objective function
MaxIt=options.iteration;          % Maximum Number of Iterations
nPop=options.clsize;               % Population Size
nArchive=options.nArchive;        % Archive Size
K=round(sqrt(nPop+nArchive));  % KNN Parameter
%--------------------------------------------------------------------------
% Initialization
empty_individual.Position=[];
empty_individual.Cost=[];
empty_individual.S=[];
empty_individual.R=[];
empty_individual.sigma=[];
empty_individual.sigmaK=[];
empty_individual.D=[];
empty_individual.F=[];

pop=repmat(empty_individual,nPop,1);
VarSize=length(options.ll);
for i=1:nPop
    pop(i).Position=unifrnd(options.ll,options.ul,[1 VarSize]);
    pop(i).Cost=feval(ObjFunction,pop(i).Position).';
end

archive=[];
archiveF=[];

%% Main Loop

for it=1:MaxIt
    
    Q=[pop
        archive];
    nQ=numel(Q);
    dom=false(nQ,nQ);
    
    for i=1:nQ
        Q(i).S=0;
    end
    
    for i=1:nQ
        for j=i+1:nQ
            if Dominates(Q(i),Q(j))
                Q(i).S=Q(i).S+1;
                dom(i,j)=true;
            elseif Dominates(Q(j),Q(i))
                Q(j).S=Q(j).S+1;
                dom(j,i)=true;
            end
        end
    end
    
    S=[Q.S];
    for i=1:nQ
        Q(i).R=sum(S(dom(:,i)));
    end
    
    Z=[Q.Cost]';
    SIGMA=pdist2(Z,Z,'seuclidean');
    SIGMA=sort(SIGMA);
    for i=1:nQ
        Q(i).sigma=SIGMA(:,i);
        Q(i).sigmaK=Q(i).sigma(K);
        Q(i).D=1/(Q(i).sigmaK+2);
        Q(i).F=Q(i).R+Q(i).D;
    end
    
    nND=sum([Q.R]==0);
    if nND<=nArchive
        F=[Q.F];
        [F, SO]=sort(F);
        Q=Q(SO);
        archive=Q(1:min(nArchive,nQ));
        %-----------------------------------
        for ii=1:numel(archive)
            archiveF(:,ii)=archive(ii).Cost;
        end
        [v,ia,ic] = unique(archiveF','rows');
        archiveF=[];
        archive=archive(ia);
        %-----------------------------------
    else
        SIGMA=SIGMA(:,[Q.R]==0);
        archive=Q([Q.R]==0);
        %-----------------------------------
        for ii=1:numel(archive)
            archiveF(:,ii)=archive(ii).Cost;
        end
        [v,ia,ic] = unique(archiveF','rows');
        archiveF=[];
        archive=archive(ia);
        %-----------------------------------
        k=2;
        while numel(archive)>nArchive
            while min(SIGMA(k,:))==max(SIGMA(k,:)) && k<size(SIGMA,1)
                k=k+1;
            end
            [~, j]=min(SIGMA(k,:));
            archive(j)=[];
            SIGMA(:,j)=[];
        end
    end
    
    PF=archive([archive.R]==0); % Approximate Pareto Front
    if options.Display_Flag==1
        %     Plot Pareto Front
        figure(1);
        PFC=[PF.Cost];
        plot(PFC(1,:),PFC(2,:),'x');
        xlabel('1^{st} Objective');
        ylabel('2^{nd} Objective');
        grid on;
        pause(0.01);
        %     Display Iteration Information
        fprintf('Iteration N° is %g Number of Pareto front members is %g\n',it,numel(PF))
    end
    
    
    if it>=MaxIt
        break;
    end
    
    for iii=1:size(Q,1)
        QF(iii)=Q(iii).F;
    end
    [ii1,ii2]=sort(QF);
    best=Q(ii2(1)).Position;
    worst=Q(ii2(ceil(end))).Position;
    QF=[];
    for i = 1 : nPop
        cs_new=pop(i).Position+rand(1,length(best)).*(best-abs(pop(i).Position))-rand(1,length(best)).*(worst-abs(pop(i).Position));
        for k = 1 : VarSize
            cs_new(1,k)= max(cs_new(1,k), options.ll(k));
            cs_new(1,k)= min(cs_new(1,k), options.ul(k));
        end
        cs_new_r=feval(ObjFunction,cs_new).';
        
        if Dominates(cs_new_r,pop(i).Cost)
            pop(i).Position =cs_new;
            pop(i).Cost=cs_new_r;
        end
    end
    if rand<1
        [pop] = remove_duplicate(pop, options.ul, options.ll);
    end
end
for iPF=1:numel(PF)
    bestX(iPF,:)=PF(iPF).Position;
    bestFitness(iPF,:)=PF(iPF).Cost';
    Archive=archive;
end
end
function b=Dominates(x,y)

if isstruct(x) && isfield(x,'Cost')
    x=x.Cost;
end

if isstruct(y) && isfield(y,'Cost')
    y=y.Cost;
end
b=all(x<=y) && any(x<y);

end

function [pop] = remove_duplicate(pop, uk, lk)
for i = 1 : length(pop)
    M_1 = sort(pop(i).Position);
    for k = i+1 : length(pop)
        M_2 = sort(pop(k).Position);
        if isequal(M_1, M_2)
            m_new = floor(1+(length(pop(k).Position)-1)*(rand));
            if length(uk)==1
                pop(k).Position(m_new) = (lk + (uk - lk) * rand);
            else
                pop(k).Position(m_new) = (lk(m_new) + (uk(m_new) - lk(m_new)) * rand);
            end
        end
    end
end
end