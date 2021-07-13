function [ sampleupdate_alpha, sampleupdate_beta, sampleupdate_d]=updatepopulation(N,samplenow_alpha,samplenow_beta,samplenow_d,num_pop_SLL)
  Tbest=find(num_pop_SLL==max(num_pop_SLL)); % criterion for SLL
  Tworst=find(num_pop_SLL==min(num_pop_SLL));
  
   best_beta=samplenow_beta(Tbest(1),:);
   best_alpha=samplenow_alpha(Tbest(1),:);
   best_d=samplenow_d(Tbest(1),:);
    
   worst_beta=samplenow_beta(Tworst(1),:);    
   worst_alpha=samplenow_alpha(Tworst(1),:);
   worst_d=samplenow_d(Tworst(1),:);
  
  %sampleupdate_alpha=zeros(10,N);
  %sampleupdate_beta=zeros(10,N);
  %sampleupdate_d=zeros(10,N);
  
  for q=1:10
    ra=rand(1,2); 
    rb=rand(1,2);
    rc=rand(1,2);
    sampleupdate_alpha(q,:)=samplenow_alpha(q,:)+ra(1)*(best_alpha-abs(samplenow_alpha(q,:)))-ra(2)*(worst_alpha-abs(samplenow_alpha(q,:))); %alpha
        
    sampleupdate_beta(q,:)=samplenow_beta(q,:)+rb(1)*(best_beta-abs(samplenow_beta(q,:)))-rb(2)*(worst_beta-abs(samplenow_beta(q,:))); %alpha
   
    sampleupdate_d(q,:)=samplenow_d(q,:)+rc(1)*(best_d-abs(samplenow_d(q,:)))-rc(2)*(worst_d-abs(samplenow_d(q,:)));
    
  end


end
