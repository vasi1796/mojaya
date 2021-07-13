function [ sampleupdate_alpha, sampleupdate_d]=updatepopulation(N,samplenow_alpha,samplenow_d,num_pop_SLL)
  Tbest=find(num_pop_SLL==max(num_pop_SLL));
  Tworst=find(num_pop_SLL==min(num_pop_SLL));
  
  best_alpha=samplenow_alpha(Tbest(1),:);
  best_d=samplenow_d(Tbest(1),:);
 
  worst_alpha=samplenow_alpha(Tworst(1),:);
  worst_d=samplenow_d(Tworst(1),:);
  
  sampleupdate_alpha=zeros(10,N);
  sampleupdate_d=zeros(10,N);
  
  for q=1:10
    ra=rand(1,2);
    rc=rand(1,2);
 
    % phase shift update
    sampleupdate_alpha(q,:)=samplenow_alpha(q,:)+ra(1)*(best_alpha-abs(samplenow_alpha(q,:)))-ra(2)*(worst_alpha-abs(samplenow_alpha(q,:)));
    % element distance update
    sampleupdate_d(q,:)=samplenow_d(q,:)+rc(1)*(best_d-abs(samplenow_d(q,:)))-rc(2)*(worst_d-abs(samplenow_d(q,:)));

  end


end
