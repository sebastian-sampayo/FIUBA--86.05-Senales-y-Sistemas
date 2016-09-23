% Proyecto Especial
% Ejercicio 6.test.

clear all;
close all;
% 
% %% Filtro
% Hs_LP_2orden = @(s, xi, wr) ((wr.^2)./(s.^2 + 2*xi*wr.*s + wr.^2));

%% Par�metros
fmax = 1220;
BW = 70;
tolerance = .01;

minf = 100;
maxf = 3000;
frecuency = logspace(log10(minf), log10(maxf), 10000);
xi = linspace(0.01, .5 ,1000);

%% Te�rico
% fm = wr/(2*pi)*sqrt(1-2*xi.^2);
% file = fopen('ej04_maximosteoricos.txt','w');
% fprintf(file, 'xi | Frecuencia M�xima Te�rica\n\n');
% fprintf(file, '%.2g | %.5g\n', [xi; fm]);
% fclose(file);
%% Comprobaci�n gr�fica
% hold all;
for j=1:length(xi)
    wr = 2*pi*fmax./(sqrt(1-2*xi(j).^2));
    absH = abs(Hs_LP_2orden(i*frecuency*2*pi, xi(j), wr));
    dbH = 20*log10(absH);
    M = max(dbH);
    fm = frecuency(find(dbH==M));
    nBW = find(dbH > M-3);
    BWaprox = frecuency(nBW(end)) - frecuency(nBW(1));
    error = abs(BWaprox/BW - 1);
    if error<tolerance
        str = sprintf('xi = %.3g | BW = %.5g Hz', xi(j), BWaprox);
        disp(str);
    end;
%     semilogx(frecuency, dbH)
%     str_legend{j} = sprintf('\\xi = %.2g | \\itf_{max}\\rm = %.5gHz | BW = %.5gHz',xi(j), fm, BW);
end
% grid minor;
% axis([minf maxf -20 15]);
% legend(str_legend, 'Location', 'NorthEast');
% title('Sistema Pasabajos de Segundo Orden.  (\omega_r = 2\pi1KHz)');
% xlabel('Frecuencia [Hz]');
% ylabel('Transferencia |H(s)|  [dB]');

% print('-dpng', 'ej05_BWvsXi.png');