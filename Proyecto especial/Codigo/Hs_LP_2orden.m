% Filtro Pasabajos de Segundo Orden
% 
% Uso:
% H = Hs_LP_2orden(s, xi, wr)
%
% Donde:            wr^2
%   H(s) = ----------------------
%          s^2 + 2*xi*wr*s + wr^2
%

function H = Hs_LP_2orden(s, xi, wr)
    H = (wr.^2)./(s.^2 + 2*xi.*wr.*s + wr.^2);
end