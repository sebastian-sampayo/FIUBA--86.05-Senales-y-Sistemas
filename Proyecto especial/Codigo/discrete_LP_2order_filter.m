% Obtiene a partir de los parámetros del filtro, la señal y 
% la frecuencia de muestreo, la salida del filtro.
%
% Uso:
% y = discrete_LP_2orden_filter(x, wr, xi, Fs)
%
% Donde:            wr^2
%   H(s) = ----------------------
%          s^2 + 2*xi*wr*s + wr^2
%

function y = discrete_LP_2order_filter(x, wr, xi, Fs)
    alpha = wr/sqrt(1-xi^2);
    beta = wr*xi;
    gamma = wr * sqrt(1-xi);
    A = alpha * exp(-beta/Fs) * sin(gamma/Fs) /Fs;
    B = 2 * exp(-beta/Fs) * cos(gamma/Fs);
    C = exp((-beta*2)/Fs);
    
    % A*x(n) = y(n) - B*y(n-1) + C*y(n-2)
    y = filter([A 0 0], [1 -B C], x);
end