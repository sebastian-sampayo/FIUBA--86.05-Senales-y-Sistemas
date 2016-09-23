% Proyecto Especial
% Ejercicio 7.

% Al informe
% Para generar la señal del tren de pulsos glóticos, se debe filtrar un tren
% de pulsos con Hg. En una primera aproximación, para implementar la
% solución a este problema, se buscó la transformada inversa de Laplace
% del filtro Hg(s), obteniendo la respuesta impulsiva hg(t). Luego se
% convolucionó esta señal con un tren de pulsos con una frecuencia de 150Hz.

clear all;
close all;

% Parámetros del filtro
wr = 7.14*10^3;
xi = 4300/(2*wr);

Fg = 150; % Frecuencia Glótica
Tg = 1/Fg;

N = 1000;
tmax = 4*Tg;
t = linspace(0, tmax, N);
Ts = t(2) - t(1); % Período de muestreo
% Busco a que muestra corresponde Tg:
n_Tg = ceil(Tg/Ts);
% Genero el tren de deltas:
d_train = zeros(1, N);
d_train(1)=1; d_train(n_Tg)=1; d_train(2*n_Tg)=1; d_train(3*n_Tg)=1;

% Filtro:
% hg = 4500.01 * exp(-2150*t) .* sin(t*1586.66); <- mal calculado
alpha = wr/sqrt(1-xi^2);
beta = wr*xi;
gamma = wr * sqrt(1-xi);
hg = alpha * exp(-beta*t) .* sin(t*gamma) * Ts;

% Salida:
g_train = conv(d_train, hg);

% Gráficos:
figure(1)
subplot(3,1,1)
plot(t, d_train)
title('Tren de Deltas de Dirac')
xlabel('Tiempo [s]');
grid on;

subplot(3,1,2)
plot(t, hg)
title('Respuesta Impulsiva del Filtro')
xlabel('Tiempo [s]');
grid on;

subplot(3,1,3)
% t2 = linspace(0,tmax*2,2*N-1);
% [t,t+tmax+Ts,2*tmax]
plot(t, g_train(1:N))
title('Tren de Pulsos Glóticos (salida del filtro)')
xlabel('Tiempo [s]');
grid on;

print('-dpng', '../Graficos/ej07_hg.png');