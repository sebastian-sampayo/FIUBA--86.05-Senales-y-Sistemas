% Proyecto Especial
% Ejercicio 1.
% Espectrograma de "Habla.wav"
close all;
clear all;
% Cargo los limites entre fonemas. Cada valor es el comienzo de un fonema
limits = [0.106 .188 .296 .313 .396 .448 .495 .577 .594 .624 .678 .767 .876 .904 .955 .985 1.017 1.075 1.129 1.222 1.356 1.534];

file_name = '../Sounds/Habla.wav';
[habla, FS, NBITS] = wavread(file_name);
NFFT = 2^11;
windowL = NFFT/8;

figure(1)
subplot(2,1,1)
% hold on;
% spectrogram(habla, hamming(windowL)', windowL/2, NFFT, FS, 'yaxis')
[S,F,T]= spectrogram(habla, hamming(windowL)', windowL/2, NFFT, FS, 'yaxis');
pcolor(T,F,(abs(S)));shading interp
% plot no sirve para acá.
% % Creo un vector para marcar los límites de cada fonema
% y = zeros(1, length(habla));
% for i=1:length(limits)
%     plot([limits(i),limits(i)],[-1,1], 'r', 'LineWidth', 10)
% end
axis([0 1.6 0 3000])
title('Espectrograma');
% hold off;

subplot(2,1,2)
hold on;
t = linspace(0, length(habla)/FS, length(habla));
% Creo un vector para marcar los límites de cada fonema
y = zeros(1, length(habla));
for i=1:length(limits)
    plot([limits(i),limits(i)],[-1,1], 'r', 'LineWidth', 2)
end
plot(t, habla)
title('Dominio del tiempo');
axis([0 1.6 -1 1])
grid on;
grid minor;
hold off;

% print('-dpng', '../Graficos/habla.wav-fonemas.png');