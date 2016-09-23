% Proyecto Especial
% Ejercicio 11.
% Espectrograma de "Vocales.wav"
clear all;
close all;

file_name = '../Sounds/test_vocales_bi_pre_fsweep_labios.wav';
[vocals, FS, NBITS] = wavread(file_name);
NFFT = 2^11;
windowL = NFFT/8;

figure(1)
% spectrogram(vocals, hamming(windowL)', windowL/2, NFFT, FS, 'yaxis')
[S,F,T]= spectrogram(vocals, hamming(windowL)', windowL/2, NFFT, FS, 'yaxis');
pcolor(T,F,(abs(S)));shading interp
axis([0 1.5 0 3000])
title('Espectrograma. Ventana temporal chica');
xlabel('Tiempo [s]');
ylabel('Frecuencia [Hz]');

% print('-dpng', '../Graficos/ej11_small_win.png');


windowL = NFFT;
figure(2)
% spectrogram(vocals, hamming(windowL)', windowL/2, NFFT, FS, 'yaxis')
[S,F,T]= spectrogram(vocals, hamming(windowL)', windowL/2, NFFT, FS, 'yaxis');
pcolor(T,F,(abs(S)));shading interp
axis([0 1.5 0 3000])
title('Espectrograma. Ventana temporal grande');
xlabel('Tiempo [s]');
ylabel('Frecuencia [Hz]');

% print('-dpng', '../Graficos/ej11_big_win.png');