% Proyecto Especial
% Ejercicio 9.

clear all;
close all;

% Parámetros del filtro
wr = 7.14*10^3;
xi = 4300/(2*wr);

Fg = 150; % Frecuencia Glótica
Tg = 1/Fg;

Fs = 16e3; % Frecuencia de muestreo [Hz]
tmax = 4*Tg;
t = 0:(1/Fs):tmax;
N = length(t);
Ts = t(2) - t(1) % Período de muestreo
1/Fs
% Busco a que muestra corresponde Tg:
n_Tg = ceil(Tg/Ts);
% Genero el tren de deltas:
d_train = zeros(1, N);
d_train(1)=1; d_train(n_Tg)=1; d_train(2*n_Tg)=1; d_train(3*n_Tg)=1;

% Filtro analógico:
alpha = wr/sqrt(1-xi^2);
beta = wr*xi;
gamma = wr * sqrt(1-xi);
hg = alpha * exp(-beta*t) .* sin(t*gamma) * Ts;

% Salida:
g_train = conv(d_train, hg);
% Filtro digital - Muestreo:
g_train_d = discrete_LP_2order_filter(d_train, wr, xi, Fs);
% Filtro digital - Bilineal:
g_train_d_bi = discrete_LP_2order_filter_bilinear(d_train, wr, xi, Fs, 'prewarping');

% Gráficos:
figure(1)
hold all;
plot(t, g_train(2:N+1),'Linewidth',3)
plot(t, g_train_d, '-','Linewidth',2)
plot(t, g_train_d_bi, '-','Linewidth',2)
title('Tren de Pulsos Glóticos (salida del filtro)')
xlabel('Tiempo [s]');
grid on;
legend('Analógico', 'Digital-Muestreo', 'Digital-Bilineal');

% print('-dpng', '../Graficos/ej09_hg_d.png');