% Proyecto Especial
% Ejercicio 8. Sistema completo. Filtros en cascada.

clear all;
close all;

% file_out = '../Sounds/test_voweles_fg150.wav';

% T = .3; % Duración del fonema sintetizado [segundos]
Fs = 16e3; % Frecuencia de muestreo [Hz]
Ts = 1/Fs;
% N = ceil(T/Ts);
N = 1000;
n = 0:N-1;
NFFT = 10*N;
freq = linspace(0, Fs/2, floor(NFFT/2));
vowels = ['a', 'e', 'i', 'o', 'u'];
vowel = 1;

wr_matrix = 2*pi*csvread('fr_matrix_out.csv');
xi_matrix = csvread('xi_matrix_out.csv');

number_of_formants = size(wr_matrix, 2);

x = dirac(n);
data = zeros(1,5*N);

hfig = figure(1);
hold all;
%% Tranformación Bilineal con Pre-Warping
% Cascada de filtros pasabajos
y(1,:) = discrete_LP_2order_filter_bilinear(x, wr_matrix(vowel,1), xi_matrix(vowel,1), Fs, 'prewarping');
for i=2:number_of_formants
    y(i,:) = discrete_LP_2order_filter_bilinear(y(i-1,:), wr_matrix(vowel,i), xi_matrix(vowel,i), Fs, 'prewarping');
end
y = y(number_of_formants,:);

Y_fft = fft(y, NFFT);
% Tomo la primera mitad del vector (la otra es simétrica)
Y_fft = Y_fft(1:floor(NFFT/2));
Y_dB = 20*log10(abs(Y_fft));
plot(freq, abs(Y_fft), 'Linewidth', 2);
str_legend{1} = 'Transformación Bilineal con \itPre-Warping\rm';
%% Grafico formantes máximos
M = max(abs(Y_fft));
treshold = M*0.05;
[peaks, n_peaks] = findpeaks(abs(Y_fft));
n_formants = n_peaks(find(peaks>treshold));
%     nM = find(absDFT==M);
for j=1:length(n_formants)
    formant(j) = freq(n_formants(j));
    h_formant(j) = plot([formant(j), formant(j)], [0,M], '-r');
    str_legend{j+1} = sprintf('Formante %i: %.4g Hz',j,formant(j));
end
grid on;

%% Teorema de Muestreo
% Cascada de filtros pasabajos
y(1,:) = discrete_LP_2order_filter(x, wr_matrix(vowel,1), xi_matrix(vowel,1), Fs);
for i=2:number_of_formants
    y(i,:) = discrete_LP_2order_filter(y(i-1,:), wr_matrix(vowel,i), xi_matrix(vowel,i), Fs);
end
y = y(number_of_formants,:);

Y_fft = fft(y, NFFT);
% Tomo la primera mitad del vector (la otra es simétrica)
Y_fft = Y_fft(1:floor(NFFT/2));
Y_dB = 20*log10(abs(Y_fft));

plot(freq, abs(Y_fft), 'Linewidth', 2);
grid on;
axis([0 4e3 0 M*1.01]);
title('Respuesta en Frecuencia. Sistema completo');
legend(str_legend, 'Teorema de Muestreo');
xlabel('Frecuencia [Hz]');
ylabel('Transferencia |H(s)|');
% Imprimo gráfico
set(hfig,'PaperType', 'A4');
set(hfig,'PaperOrientation', 'landscape');
set(hfig,'PaperUnits', 'normalized');
xmargin=.01;
set(hfig,'PaperPosition',[xmargin xmargin 1-2*xmargin 1-2*xmargin]);
print(hfig, '-dpng', '../Graficos/ej08_cascada.png');
set(hfig,'PaperUnits', 'default');