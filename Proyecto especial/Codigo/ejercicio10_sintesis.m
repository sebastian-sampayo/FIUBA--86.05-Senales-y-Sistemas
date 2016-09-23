% Proyecto Especial
% Ejercicio 10. Test de Síntesis

clear all;
close all;

file_out = '../Sounds/mis_vocales_fg120_bi_pre_fsweep_labial0.6_900ms.wav';

T = .9; % Duración del fonema sintetizado [segundos]
Fs = 16e3; % Frecuencia de muestreo [Hz]
Ts = 1/Fs;
N = ceil(T/Ts);
n = 0:N-1;

% --- Parámetros del filtro para modelar el tren de pulsos glótico
Fg = 120; % Frecuencia Glótica [Hz]
Tg = 1/Fg;
n_Tg = ceil(Tg/Ts);
wr_g = 7.14e3;
xi_g = 4300/(2*wr_g);
% ---------------------------------------------------

% Especificación
% wr_matrix = 2*pi*csvread('fr_matrix_out.csv');
% xi_matrix = csvread('xi_matrix_out.csv');
% Grabación
% wr_matrix = 2*pi*csvread('mi_fr_matrix_out.csv');
% xi_matrix = csvread('mi_xi_matrix_out.csv');
% Grabación + F5
wr_matrix = 2*pi*csvread('mi_fr.csv');
xi_matrix = csvread('mi_xi.csv');

number_of_formants = size(wr_matrix, 2);

% Genero un tren de deltas a frecuencia glótica
% Modificación para que varíe la frecuencia
% d_train = (mod(n, n_Tg) == 0);
% Fg = (Fg + .2*sin(4*pi/N*n));%.*exp(-2*n/N));
Fg = (Fg + .2*sin(2*pi*2.5*n*Ts));
d_train = cos(2*pi*Fg.*n*Ts);
[peaks, n_peaks] = findpeaks(d_train);
d_train = zeros(1,N);
d_train(n_peaks) = 1;

% Genero tren de pulsos glóticos
% g_train = discrete_LP_2order_filter(d_train, wr_g, xi_g, Fs);
g_train = discrete_LP_2order_filter_bilinear(d_train, wr_g, xi_g, Fs, 'prewarping');

data = zeros(1,5*N);

for j=1:5
    vocal = j;
    % Cascada de filtros pasabajos
%     y(1,:) = discrete_LP_2order_filter(g_train, wr_matrix(vocal,1), xi_matrix(vocal,1), Fs);
    y(1,:) = discrete_LP_2order_filter_bilinear(g_train, wr_matrix(vocal,1), xi_matrix(vocal,1), Fs, 'prewarping');
    for i=2:number_of_formants
        if wr_matrix(vocal,i) > 0
%             y(i,:) = discrete_LP_2order_filter(y(i-1,:), wr_matrix(vocal,i), xi_matrix(vocal,i), Fs);
        y(i,:) = discrete_LP_2order_filter_bilinear(y(i-1,:), wr_matrix(vocal,i), xi_matrix(vocal,i), Fs, 'prewarping');
        else
            y(i,:) = y(i-1,:);
        end
    end

    % Filtro adicional para simular el efecto de radiación del sonido a la
    % salida de los labios
    y = 2*filter([1 -.6], [1 0], y(number_of_formants,:));
%     y = y(number_of_formants,:);
    data((1+(j-1)*N):j*N) = y;
    sound(y, Fs);
end
wavwrite(data, Fs, file_out);