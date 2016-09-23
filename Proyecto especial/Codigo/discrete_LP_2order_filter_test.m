% Proyecto Especial
% Test de funci�n "discrete_LP_2orden_filter"

% En estos gr�ficos se puede ver como la funci�n creada para filtrar guarda
% un enorme similitud con lo esperado te�ricamente.

% Preguntar que onda que cuando aumenta el xi, el m�ximo se defasa.
% Sucede para los dos casos en los que calculo la fft.

% close all;
clear all;

Fs = 16e3;
Ts = 1/Fs;
N = 10000;

wr = 2*pi*4000;
xi = .1;

maxw = 2*wr;
% maxt = N*Ts;
% t = linspace(0, maxt, N);
n=1:N;
w = linspace(0, maxw, N);

% --- Respuesta impulsiva te�rica ---
alpha = wr/sqrt(1-xi^2);
beta = wr*xi;
gamma = wr * sqrt(1-xi);
% hg = 4500.01 * exp(-2150*t) .* sin(t*1586.66);
% hg = alpha * exp(-beta*t) .* sin(t*gamma);
hg = alpha * exp(-beta*n*Ts) .* sin(n*Ts*gamma) .* Ts;
% -----------------------------------

% --- Respuesta en frecuencia te�rica ---
absHg = abs(Hs_LP_2orden(i*w, xi, wr));
dbHg = 20*log10(absHg);
% ---------------------------------------

% - FFT -
NFFT = 10*N;
k = 1:NFFT;
w_fft = k*2*pi*Fs/NFFT;
% Me quedo con la banda que me interesa, esto es hasta maxw.
k_max = ceil(maxw*NFFT/(2*pi*Fs));
w_fft = w_fft(1:k_max);
% ------
% --- Transformada de Fourier de hg te�rica ----
Hg_fft = fft(hg, NFFT);
Hg_fft = Hg_fft(1:k_max);
% ---------------------------

% --- Respuesta en frecuencia usando filtro discreto ----
d = [1 zeros(1,N-1)];
y = discrete_LP_2order_filter_bilinear(d,wr,xi, Fs, 'prewarping');
% y = discrete_LP_2order_filter(d,wr,xi, Fs);
Y_fft = fft(y, NFFT);
Y_fft = Y_fft(1:k_max);
% ---------------------------------------

figure(2)
subplot(3,1,1)
plot(w/2/pi, absHg)
title('|Hg(w)| te�rico');
grid on;
axis([0 maxw/2/pi .2 5]);

% subplot(3,1,2)
% plot(w, dbHg)
% title('|Hg(w)|dB te�rico');
% grid on;

subplot(3,1,2)
plot(w_fft/2/pi, abs(Hg_fft))
title('|Hg_exp(w)| Transformada de Fourier de hg te�rica  ');
axis([0 maxw/2/pi .2 5]);
grid on;

subplot(3,1,3)
plot(w_fft/2/pi, abs(Y_fft))
title('|Y_fft(w)| Usando "discrete\_LP\_2orden\_filter"');
grid on;
axis([0 maxw/2/pi .2 5]);