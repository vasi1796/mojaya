function [z]=checkSLL(ind_v,minSLL,AF)
   %scan AF;
   z=0;
   for i=1:length(ind_v)
       if AF(ind_v(i))<minSLL
           z=z+1;
       end          
   end
end