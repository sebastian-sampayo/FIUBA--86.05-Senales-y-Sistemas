% Proyecto Especial
% Ejercicio 4.
% No utilizado, incluído en ejercicio05.m que es más completo.

clear all;
close all;

%% Filtro
LP_2orden = @(s, xi, wr) ((wr^2)./(s.^2 + 2*xi*wr.*s + wr^2));

%% Parámetros
wr = 2*pi*1000;
minf = 100;
maxf = 3000;
frecuency = logspace(log10(minf), log10(maxf), 10000);
xi = linspace(0.1, .5 ,5);

%% Teórico
fm = wr/(2*pi)*sqrt(1-2*xi.^2);
file = fopen('ej04_maximosteoricos.txt','w');
fprintf(file, 'xi | Frecuencia Máxima Teórica\n\n');
fprintf(file, '%.2g | %.5g\n', [xi; fm]);
fclose(file);
%% Comprobación gráfica
hold all;
for j=1:5
    absH = abs(LP_2orden(i*frecuency*2*pi, xi(j), wr));
    semilogx(frecuency, 20*log10(absH))
    fm = frecuency(find(absH==max(absH)));
    str_legend{j} = sprintf('\\xi = %.2g | \\itf_{max}\\rm = %.5g',xi(j), fm);
end
grid on;
axis([minf maxf -20 15]);
legend(str_legend, 'Location', 'East');
title('Sistema Pasabajos de Segundo Orden.  (\omega_r = 2\pi1KHz)');
xlabel('Frecuencia [Hz]');
ylabel('Transferencia |H(s)|  [dB]');

% print('-dpng', '../Graficos/ej04_Hvsxi.png');