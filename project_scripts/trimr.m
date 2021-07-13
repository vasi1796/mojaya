function [z1,z2]=trimr(alpha_min, alpha_max, d_min, d_max, sampleupdate_alpha, sampleupdate_d)
   [row,col]=size(sampleupdate_alpha);
   for i=1:col
       sampleupdate_alpha(sampleupdate_alpha(:,i)<alpha_min,i)=alpha_min;
       sampleupdate_alpha(sampleupdate_alpha(:,i)>alpha_max,i)=alpha_max;
       
       sampleupdate_d(sampleupdate_d(:,i)<d_min,i)=d_min;
       sampleupdate_d(sampleupdate_d(:,i)>d_max,i)=d_max;         
   end
  z1=sampleupdate_alpha;
  z2=sampleupdate_d;

end
