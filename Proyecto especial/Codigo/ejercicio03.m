% Proyecto Especial
% Ejercicio 3.

% Al informe.
% En este caso se separó cada una de las vocales en archivos distintos.
% Luego se graficó la DFT de cada señal multiplicada por una ventana
% cuadrada. El objetivo de esto es conocer la envolvente del espectro para
% cada vocal (sabiendo que el espectro real es un tren de pulsos modulado),
% con lo cual se jugó con los valores del largo de la ventana
% y de la cantidad de puntos de DFT para visualizarla mejor. Además, se
% buscó, a través de un offset, en que instante ventanear para evidenciar
% mejor los formantes. Al disminuir el largo temporal de la ventana
% aplicada, el ancho de la sinc que convoluciona en frecuencia con el
% espectro es mayor, prácticamente interpolando de esta manera los picos
% del tren de pulsos, es decir, permitiendo que el resultado se enfoque 
% en la envolvente. Por otro lado, la cantidad de puntos de la DFT,
% determina la resolución en frecuencia, i.e. la cantidad de muestras
% tomadas del espectro convolucionado.
% 
% Adicionalmente, se agregó un algoritmo muy breve con el cual detectar
% los picos más altos de cada espectro, que en principio serían los
% mayores formantes. Esta rutina en primer lugar detecta el máximo
% absoluto del espectro (M). Luego decide si el pico es formante o no
% según el valor del pico sea mayor o menor que un umbral establecido
% en base al máximo absoluto M. En este caso se eligió un umbral de 0.22M.

clear all;

[vocals{1}, FS(1), NBITS(1)] = wavread('../Sounds/a.wav');
[vocals{2}, FS(2), NBITS(2)] = wavread('../Sounds/e.wav');
[vocals{3}, FS(3), NBITS(3)] = wavread('../Sounds/i.wav');
[vocals{4}, FS(4), NBITS(4)] = wavread('../Sounds/o.wav');
[vocals{5}, FS(5), NBITS(5)] = wavread('../Sounds/u.wav');

% FS = FS(1);
vocal_name=['a','e','i','o','u'];

NFFT = 2^11;
k = 1:NFFT;
% Tomo la mitad de los puntos calculados
frecuency = k(1:ceil(end/2))*FS(1)/NFFT;

hfig = figure(1);
for i=1:5
    subplot(5,1,i)
    L = length(vocals{i});
    %% Venataneo
    windowL = ceil(NFFT/25); % NFFT/25 (NFFT=2^11)
    offset = ceil(5*NFFT/10); % 2*L/10, 5*NFFT/10 (NFFT=2^11)
    window = [zeros(offset,1); ones(windowL,1); zeros(L-windowL-offset,1)];
    DFT = fft(vocals{i} .* window, NFFT);
    % Tomo valor absoluto de la mitad de los puntos calculados
    absDFT = abs(DFT(1:ceil(end/2)));
    hold on;
    h_DFT = plot(frecuency, absDFT);
    str_legend{1} = sprintf('FFT: %i puntos.\nVentana: %i puntos',NFFT, windowL);
    %% Grafico formantes máximos
    M = max(absDFT);
    treshold = M*0.22;
    [peaks, n_peaks] = findpeaks(absDFT);
    n_formants = n_peaks(find(peaks>treshold));
%     nM = find(absDFT==M);
    for j=1:length(n_formants)
        formant(j) = frecuency(n_formants(j));
        h_formant(j) = plot([formant(j), formant(j)], [0,M], '-r');
        str_legend{j+1} = sprintf('Formante %i: %.4g Hz',j,formant(j));
    end
    
    %% Estética del gráfico
%     legend(h_DFT, str_legend_DFT);
%     legend(h_formant, str_legend_formants,'Southeast');
    legend([h_DFT,h_formant], str_legend, 'Location', 'East');
    axis([0 FS(1)/2 0 M*1.1]);
    grid on;
    str = sprintf('Vocal: %s.', vocal_name(i));
    title(str);
    xlabel('Frecuencia [Hz]');
end

%% Imprimo gráfico
set(hfig,'PaperType', 'A4');
set(hfig,'PaperUnits', 'normalized');
xmargin=.01;
set(hfig,'PaperPosition',[xmargin xmargin 1-2*xmargin 1-2*xmargin]);
% print(hfig, '-dpng', '../Graficos/ej03_Vocals_DFT.png');
set(hfig,'PaperUnits', 'default');