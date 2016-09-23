% Proyecto Especial
% Ejercicio 5.

clear all;
close all;

%% Filtro
% LP_2orden = @(s, xi, wr) ((wr^2)./(s.^2 + 2*xi*wr.*s + wr^2));

%% Parámetros
wr = 2*pi*1000;
minf = 100;
maxf = 3000;
frecuency = logspace(log10(minf), log10(maxf), 10000);
xi = linspace(0.1, .5 ,5);

%% Teórico
% fm = wr/(2*pi)*sqrt(1-2*xi.^2);
% file = fopen('ej04_maximosteoricos.txt','w');
% fprintf(file, 'xi | Frecuencia Máxima Teórica\n\n');
% fprintf(file, '%.2g | %.5g\n', [xi; fm]);
% fclose(file);
%% Comprobación gráfica
hold all;
for j=1:5
    absH = abs(Hs_LP_2orden(i*frecuency*2*pi, xi(j), wr));
    dbH = 20*log10(absH);
    semilogx(frecuency, dbH)
    M = max(dbH);
    fm = frecuency(find(dbH==M));
    nBW = find(dbH > M-3);
    BW = frecuency(nBW(end)) - frecuency(nBW(1));
    str_legend{j} = sprintf('\\xi = %.2g | \\itf_{max}\\rm = %.5gHz | BW = %.5gHz',xi(j), fm, BW);
end
grid minor;
axis([minf maxf -20 15]);
legend(str_legend, 'Location', 'NorthEast');
title('Sistema Pasabajos de Segundo Orden.  (\omega_r = 2\pi1KHz)');
xlabel('Frecuencia [Hz]');
ylabel('Transferencia |H(s)|  [dB]');

% print('-dpng', '../Graficos/ej05_BWvsXi.png');