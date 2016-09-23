% Proyecto Especial
% Ejercicio 12.
% Espectrograma de "mis_Vocales.wav"
clear all;
close all;

file_name = '../Sounds/mis_Vocales.wav';
[vocals, FS, NBITS] = wavread(file_name);
NFFT = 2^11;
windowL = 450;

figure(1)
% spectrogram(vocals, hamming(windowL)', windowL/2, NFFT, FS, 'yaxis')
[S,F,T]= spectrogram(vocals, hamming(windowL)', windowL/2, NFFT, FS, 'yaxis');
pcolor(T,F,log10(abs(S)));shading interp
axis([0 length(vocals)/FS 0 6000])
title('Espectrograma. Ventana temporal chica');
xlabel('Tiempo [s]');
ylabel('Frecuencia [Hz]');

% print('-dpng', '../Graficos/ej12_small_win.png');


windowL = NFFT;
figure(2)
% spectrogram(vocals, hamming(windowL)', windowL/2, NFFT, FS, 'yaxis')
[S,F,T]= spectrogram(vocals, hamming(windowL)', windowL/2, NFFT, FS, 'yaxis');
pcolor(T,F,(abs(S)));shading interp
axis([0 length(vocals)/FS 0 4000])
title('Espectrograma. Ventana temporal grande');
xlabel('Tiempo [s]');
ylabel('Frecuencia [Hz]');

% print('-dpng', '../Graficos/ej12_big_win.png');