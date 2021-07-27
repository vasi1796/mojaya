function [z1,z2,z3]=trimr(alpha_min, alpha_max, d_min, d_max,I_min,I_max, sampleupdate_alpha, sampleupdate_d, sampleupdate_I)
   [row,col]=size(sampleupdate_alpha);
   for i=1:col
       sampleupdate_alpha(sampleupdate_alpha(:,i)<alpha_min,i)=alpha_min;
       sampleupdate_alpha(sampleupdate_alpha(:,i)>alpha_max,i)=alpha_max;
       
       sampleupdate_d(sampleupdate_d(:,i)<d_min,i)=d_min;
       sampleupdate_d(sampleupdate_d(:,i)>d_max,i)=d_max;
       
       sampleupdate_I(sampleupdate_I(:,i)<I_min,i)=I_min;
       sampleupdate_I(sampleupdate_I(:,i)<I_max,i)=I_max;
   end
  z1=sampleupdate_alpha;
  z2=sampleupdate_d;
  z3=sampleupdate_I;

end
