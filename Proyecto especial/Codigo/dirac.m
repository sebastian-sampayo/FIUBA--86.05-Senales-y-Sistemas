% Delta de Dirac
%
% d = dirac(n)
%
% d = | 1  si n=0
%     | 0  e.o.c.


function d = dirac(n)
    d = (n==0);
end