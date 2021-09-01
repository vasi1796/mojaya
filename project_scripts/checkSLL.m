function [obj_fun,z_1,z_2]=checkSLL(ind_v,minSLL,AF,ind_w,w_1,w_2)
   %scan AF;
   z_1=0;
   z_2=0;
   % min SLL
   for i=1:length(ind_v)
       if AF(ind_v(i))<minSLL
           z_1=z_1+1;
       end          
   end
   % max main lobes
   for i=1:length(ind_w)
       if AF(ind_w(i))>minSLL
           z_2=z_2+1;
       end          
   end
   % weighted sum objective function
   obj_fun=w_1*z_1+w_2*z_2;
end