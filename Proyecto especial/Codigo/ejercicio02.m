% Proyecto Especial
% Ejercicio 2.
% Espectrograma de "Vocales.wav"
clear all;
close all;

file_name = '../Sounds/Vocales.wav';
[vocals, FS, NBITS] = wavread(file_name);
NFFT = 2^11;
windowL = NFFT/8;

figure(1)
% spectrogram(vocals, hamming(windowL)', windowL/2, NFFT, FS, 'yaxis')
[S,F,T]= spectrogram(vocals, hamming(windowL)', windowL/2, NFFT, FS, 'yaxis');
pcolor(T,F,(abs(S)));shading interp
axis([0 4 0 4000])
title('Espectrograma. Ventana temporal chica');

% print('-dpng', '../Graficos/ej02_small_win.png');


windowL = NFFT;
figure(2)
% spectrogram(vocals, hamming(windowL)', windowL/2, NFFT, FS, 'yaxis')
[S,F,T]= spectrogram(vocals, hamming(windowL)', windowL/2, NFFT, FS, 'yaxis');
pcolor(T,F,(abs(S)));shading interp
axis([0 4 0 4000])
title('Espectrograma. Ventana temporal grande');

% print('-dpng', '../Graficos/ej02_big_win.png');