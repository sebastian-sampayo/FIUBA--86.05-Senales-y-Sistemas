% Proyecto Especial
% Ejercicio 8.

clear all;
close all;

fmax_out_file_name = 'ej08_comparacion_fmax.csv';
BW_out_file_name = 'ej08_comparacion_BW.csv';
wr_matrix = 2*pi*csvread('fr_matrix_out.csv');
xi_matrix = csvread('xi_matrix_out.csv');
fmax_original_matrix = 2*pi*csvread('fmax_matrix_in.csv');
vowels = ['a', 'e', 'i', 'o', 'u'];
vowel = 1;

fmax = zeros(4,size(fmax_original_matrix));
BW = zeros(4,size(fmax_original_matrix));

Fs = 16e3;
Ts = 1/Fs;
N = 10000;
n=0:N-1;
NFFT = 10*N;
freq = linspace(0, Fs/2, floor(NFFT/2));

x = dirac(n);
for i=1:size(wr_matrix,2)
    wr = wr_matrix(vowel, i);
    xi = xi_matrix(vowel, i);
    
    hfig = figure(i);
    hold all;
    
    % ------ Teórico
    Y_fft = Hs_LP_2orden(j*freq*2*pi, xi, wr);
    Y_dB = 20*log10(abs(Y_fft));
    
    M = max(Y_dB);
    nM = find(Y_dB==M);
    fmax(1,i) = freq(nM); % nM*Fs/NFFT;
    nBW = find(Y_dB > M-3);
    BW(1,i) = freq(nBW(end)) - freq(nBW(1));% nBW(end)*Fs/NFFT - nBW(1)*Fs/NFFT;
    
    hplot(1) = plot(freq, Y_dB, 'k');
    str_legend{1} = sprintf('Teórico | \\itf_{max}\\rm = %.5gHz | BW = %.5gHz', fmax(1,i), BW(1,i));
    
    % ------- Utilizando el Teorema de Muestreo:
    y = discrete_LP_2order_filter(x, wr, xi, Fs);
    
    Y_fft = fft(y, NFFT);
    % Tomo la primera mitad del vector (la otra es simétrica)
    Y_fft = Y_fft(1:floor(NFFT/2));
    Y_dB = 20*log10(abs(Y_fft));
    
    M = max(Y_dB);
    nM = find(Y_dB==M);
    fmax(2,i) = freq(nM); % nM*Fs/NFFT;
    nBW = find(Y_dB > M-3);
    BW(2,i) = freq(nBW(end)) - freq(nBW(1));% nBW(end)*Fs/NFFT - nBW(1)*Fs/NFFT;
    
    hplot(2) = plot(freq, Y_dB);
    str_legend{2} = sprintf('Teorema de Muestreo | \\itf_{max}\\rm = %.5gHz | BW = %.5gHz', fmax(2,i), BW(2,i));
    
    % ------ Transformación Bilineal Sin Pre-Warping
    y = discrete_LP_2order_filter_bilinear(x, wr, xi, Fs);
    
    Y_fft = fft(y, NFFT);
    % Tomo la primera mitad del vector (la otra es simétrica)
    Y_fft = Y_fft(1:floor(NFFT/2));
    Y_dB = 20*log10(abs(Y_fft));
    
    M = max(Y_dB);
    nM = find(Y_dB==M);
    fmax(3,i) = freq(nM); % nM*Fs/NFFT;
    nBW = find(Y_dB > M-3);
    BW(3,i) = freq(nBW(end)) - freq(nBW(1));% nBW(end)*Fs/NFFT - nBW(1)*Fs/NFFT;
    
    hplot(3) = plot(freq, Y_dB);
    str_legend{3} = sprintf('Bilineal | \\itf_{max}\\rm = %.5gHz | BW = %.5gHz', fmax(3,i), BW(3,i));
    
    % ----- Transformación Bilineal Con Pre-Warping
    y = discrete_LP_2order_filter_bilinear(x, wr, xi, Fs, 'prewarping');
    
    Y_fft = fft(y, NFFT);
    % Tomo la primera mitad del vector (la otra es simétrica)
    Y_fft = Y_fft(1:floor(NFFT/2));
    Y_dB = 20*log10(abs(Y_fft));
    
    M = max(Y_dB);
    nM = find(Y_dB==M);
    fmax(4,i) = freq(nM); % nM*Fs/NFFT;
    nBW = find(Y_dB > M-3);
    BW(4,i) = freq(nBW(end)) - freq(nBW(1));% nBW(end)*Fs/NFFT - nBW(1)*Fs/NFFT;
    
    hplot(4) = plot(freq, Y_dB);
    str_legend{4} = sprintf('Bilineal con \\itPre-Warping\\rm | \\itf_{max}\\rm = %.5gHz | BW = %.5gHz', fmax(4,i), BW(4,i));
    
    % ------ Estética del grafico
    legend(hplot, str_legend, 'Location', 'NorthEast');
    grid on;
    axis([0 min(fmax(4,i)*2.5, Fs/2) -5 M*1.2]);
    xlabel('Frecuencia [Hz]');
    ylabel('Transferencia |H(s)|  [dB]');
    title('Respuesta en Frecuencia del filtro');
    
    % Imprimo gráfico
    set(hfig,'PaperType', 'A4');
    set(hfig,'PaperOrientation', 'landscape');
    set(hfig,'PaperUnits', 'normalized');
    xmargin=.01;
    set(hfig,'PaperPosition',[xmargin xmargin 1-2*xmargin 1-2*xmargin]);
    print(hfig, '-dpng', strcat('../Graficos/ej08_filtro',int2str(i),'.png'));
    set(hfig,'PaperUnits', 'default');
end

% Salida CSV
% Cabezera
% header = [ [], [], 'F1', 'F2', 'F3', 'F4', 'F5'];
% col0 = [ []; []; 'Tranformación Bilineal'; []];
% col1 = ['Teórico (Especificación)'; 'Teorema de Muestreo'; 'Sin Pre-Warping'; 'Con Pre-Warping'];
% csvwrite(fmax_out_file_name, [header; [col0, col1, fmax]]);
% csvwrite(BW_out_file_name, [header; [col0, col1, BW]]);
csvwrite(fmax_out_file_name, fmax);
csvwrite(BW_out_file_name, BW);
% table_out_file = fopen(table_out_file_name,'w');
% % Cabezera:
% % fprintf(table_out_file, ',,,,,,,,,,,,,,,"Transformación Bilineal",,,,,,,,,\n');
% fprintf(table_out_file, '"Vocal","Especificación",,,,,"Teorema de Muestreo",,,,\n');%,"Sin Pre-Warping",,,,,"Con Pre-Warping",,,,\n');
% fprintf(table_out_file, ',"F1","F2","F3","F4","F5","F1","F2","F3","F4","F5"\n');%,"F1","F2","F3","F4","F5","F1","F2","F3","F4","F5"\n');
% % Vocal
% fprintf(table_out_file, '%s',vowels(vowel));
% % Especificación
% for i=1:size(fmax_original_matrix)
%     fprintf(table_out_file, ',%.5g,%.5g,%.5g,%.5g,%.5g',fmax_original_matrix(vowel,i));
% end
% 
% fclose(table_out_file);
    