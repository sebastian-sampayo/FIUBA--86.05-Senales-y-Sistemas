% Obtiene a partir de los parámetros del filtro, la señal y 
% la frecuencia de muestreo, la salida del filtro a través de una
% transformación bilineal. Opcional: Pre-Warping en la frecuencia wr.
%
% Uso:
% y = discrete_LP_2order_filter_bilinear(x, wr, xi, Fs [, 'prewarping'])
%
% Donde:            wr^2
%   H(s) = ----------------------
%          s^2 + 2*xi*wr*s + wr^2
%
% En realidad, la frecuencia que se desea conservar es fm (donde se 
% encuentra el máximo) que es distinta de fr. Sin embargo, como fm<fr y muy
% cercana, se asegura que si fr se preserva, fm también lo hará.

function y = discrete_LP_2order_filter_bilinear(x, wr, xi, Fs, varargin)
    str = 'prewarping';
    if nargin == 5
        if (strcmp(varargin{1}, str))
            wr0 = wr;
            wr = 2*Fs*tan(wr/(2*Fs));
            xi = xi*(wr/wr0)^2;
        end
    end

    a0 = 4*Fs^2 + 4*Fs*xi*wr + wr^2;
    a1 = -4*Fs^2 + 4*Fs*xi*wr + 3*wr^2;
    a2 = -4*Fs^2 - 4*Fs*xi*wr + 3*wr^2;
    a3 = 4*Fs^2 - 4*Fs*xi*wr + wr^2;
    
    b0 = wr^2;
    b1 = 3*wr^2;
    b2 = 3*wr^2;
    b3 = wr^2;

    a = [a0 a1 a2 a3];
    b = [b0 b1 b2 b3];
    % A*x(n) = y(n) - B*y(n-1) + C*y(n-2)
    y = filter(b, a, x);
end