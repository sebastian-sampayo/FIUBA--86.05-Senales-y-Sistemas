% Proyecto Especial
% Ejercicio 12.

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
% close all;

[vocals{1}, FS(1), NBITS(1)] = wavread('../Sounds/mi_a.wav');
[vocals{2}, FS(2), NBITS(2)] = wavread('../Sounds/mi_e.wav');
[vocals{3}, FS(3), NBITS(3)] = wavread('../Sounds/mi_i.wav');
[vocals{4}, FS(4), NBITS(4)] = wavread('../Sounds/mi_o.wav');
[vocals{5}, FS(5), NBITS(5)] = wavread('../Sounds/mi_u.wav');

fmax_file_name = 'mi_fmax.csv';
BW_file_name = 'mi_BW.csv';

% FS = FS(1);
vocal_name=['a','e','i','o','u'];

NFFT = 2^13;
k = 1:NFFT;
% Tomo la mitad de los puntos calculados
maxk = ceil(NFFT/8);
freq = k(1:maxk)*FS(1)/NFFT;

fmax = zeros(5,4);
BW = zeros(5,4);

hfig = figure(1);
clf;
for i=1:5
    subplot(5,1,i)
    L = length(vocals{i});
    %% Venataneo
    windowL = 450; % 450
    if i==1
        windowL = 450;
    elseif i==3
        windowL = 450; %450
    end
    % Diferentes offset para cada vocal para encontrar el momento en que se
    % distingan mejorlos formantes.
    if i==1
        offset = ceil(11*L/20);
    elseif i==2
        offset = ceil(10.9*L/20); %10.89
    elseif i==3
        offset = ceil(10.89*L/20);  %10.89
    elseif i==4
        offset = ceil(10.89*L/20); 
    elseif i==5
        offset = ceil(10.82*L/20); 
    end
%     window = [zeros(offset,1); ones(windowL,1); zeros(L-windowL-offset,1)];
    window = [hamming(windowL); zeros(L-offset-windowL,1)];
    x = vocals{i};
    x = x(offset+1:L);
    DFT = fft(x .* window, NFFT);
    % Tomo valor absoluto de la mitad de los puntos calculados
    absDFT = abs(DFT(1:maxk));
    hold on;
%     h_DFT = plot(freq, absDFT);
    dbDFT = 20*log10(absDFT);
    h_DFT = plot(freq, dbDFT);
    str_legend{1} = sprintf('FFT: %i puntos.\nVentana: %i puntos',NFFT, windowL);
    %% Grafico formantes máximos y Ancho de Banda
    M = max(absDFT);
    % Diferentes umbrales para cada fonema
    if i==1
        treshold = M*0.025;
    elseif i==2
        treshold = M*0.051;
    elseif i==3
        treshold = M*0.05; %.05
    else
        treshold = M*0.015;
    end
    [peaks, n_peaks] = findpeaks(absDFT);
    n_formants = n_peaks(find(peaks>treshold));
    % Descarto el primero, dado que supongo que está relacionada a 
    % la fundamental glótica y no a los formantes.
    n_formants = n_formants(2:end);
%     nM = find(absDFT==M);
    for j=1:length(n_formants)
        formant(j) = freq(n_formants(j));
        h_formant(j) = plot([formant(j), formant(j)], [-25,30], '-r');
        if j>size(fmax,2)
            fmax = [fmax zeros(size(fmax,1),1)];
        end
        fmax(i,j) = formant(j);
        % Ancho de Banda
        M2 = dbDFT(n_formants(j));
        % Al ser un máximo local, trabajo sobre la cercanía de este
        % Factor de cercanía. Si es 1 es promedio exacto entre máximos 
        % sucesivos, si es mayor a 1 se acerca al maximo actual
%         c = 1.1;
%         if j==1
%             local = floor(1:(c*n_formants(j)+n_formants(j+1))/2);
%         elseif j==length(n_formants)
%             local = floor((c*n_formants(j)+n_formants(j-1))/2:maxk);
%         else
%             local = floor((c*n_formants(j)+n_formants(j-1))/2:(c*n_formants(j)+n_formants(j+1))/2);
%         end
% %         nM2 = find(dbDFT==M2);
% %         fmax(1,i) = freq(nM2); % nM*Fs/NFFT;
%         nBW = find(dbDFT(local) > M2-3);
        if j==1
            max_p = n_formants(j+1);
        elseif j==length(n_formants)
            max_p = n_formants(j-1);
        else
            max_p = max(n_formants(j)-n_formants(j-1), n_formants(j+1)-n_formants(j));
        end
        flag1=0;
        flag2=0;
        for p=1:max_p
            if n_formants(j)-p > 0
                if (dbDFT(n_formants(j)-p) < M2-3) && (flag1 == 0)
                    nBW(1) = n_formants(j)-p+1;
                    flag1 = 1; % Se encontro el límite izq
                end
            else % Caso límite
                nBW(1) = 1;
                flag1 = 1; % Se encontro el límite izq
            end
            if n_formants(j)+p < maxk
                if dbDFT(n_formants(j)+p) < M2-3 && flag2 == 0
                    nBW(2) = n_formants(j)+p-1;
                    flag2 = 1; % Se encontro el límite der
                end
            else % Caso límite
                nBW(2) = maxk;
                flag2 = 1; % Se encontro el límite der
            end
            if (flag1==1) && (flag2==1)
                break
            end
        end
        if j>size(BW,2)
            BW = [BW zeros(size(BW,1),1)];
        end
        BW(i,j) = freq(nBW(end)) - freq(nBW(1));
        
        str_legend{j+1} = sprintf('Formante %i: %.4g Hz | B_w = %.4g Hz',j,formant(j), BW(i,j));
    end
    %% Estética del gráfico
%     legend(h_DFT, str_legend_DFT);
%     legend(h_formant, str_legend_formants,'Southeast');
    legend([h_DFT,h_formant(1:j)], str_legend, 'Location', 'East');
%     axis([0 freq(maxk) 0 M*1.1]);
    axis([0 freq(maxk)*2 -32 30]);
    grid on;
    str = sprintf('Vocal: %s.', vocal_name(i));
    title(str);
    xlabel('Frecuencia [Hz]');
    ylabel('[dB]');
end

%% Imprimo Tablas
% SOBREESCRIBE VALORES AÑADIDOS MANUALMENTE
% csvwrite(fmax_file_name, fmax);
% csvwrite(BW_file_name, BW);

%% Imprimo gráfico
set(hfig,'PaperType', 'A4');
set(hfig,'PaperUnits', 'normalized');
xmargin=.001;
set(hfig,'PaperPosition',[xmargin xmargin 1-2*xmargin 1-2*xmargin]);
% print(hfig, '-dpng', '../Graficos/ej12_Vocales_DFT_dB_Bw.png');
set(hfig,'PaperUnits', 'default');