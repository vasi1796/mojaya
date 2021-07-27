function [ sampleupdate_alpha, sampleupdate_d, sampleupdate_I ]=updatepopulation(N,samplenow_alpha,samplenow_d,samplenow_I,num_pop_SLL,pop)
  Tbest=find(num_pop_SLL==max(num_pop_SLL));
  Tworst=find(num_pop_SLL==min(num_pop_SLL));
  
  best_alpha=samplenow_alpha(Tbest(1),:);
  best_d=samplenow_d(Tbest(1),:);
  best_beta=samplenow_I(Tbest(1),:);
 
  worst_alpha=samplenow_alpha(Tworst(1),:);
  worst_d=samplenow_d(Tworst(1),:);
  worst_beta=samplenow_I(Tworst(1),:);
  
  for q=1:10
    ra=rand(1,2);
    rc=rand(1,2);
    rb=rand(1,2);
 
    % phase shift update
    sampleupdate_alpha(q,:)=samplenow_alpha(q,:)+ra(1)*(best_alpha-abs(samplenow_alpha(q,:)))-ra(2)*(worst_alpha-abs(samplenow_alpha(q,:)));
    % element distance update
    sampleupdate_d(q,:)=samplenow_d(q,:)+rc(1)*(best_d-abs(samplenow_d(q,:)))-rc(2)*(worst_d-abs(samplenow_d(q,:)));
    % magnitude update
    sampleupdate_I(q,:)=samplenow_I(q,:)+rb(1)*(best_beta-abs(samplenow_I(q,:)))-rb(2)*(worst_beta-abs(samplenow_I(q,:)));
  end


end
