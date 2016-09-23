% Proyecto Especial
% Ejercicio 8.

% Al informe:
% En este caso se busco la soluci�n general para discretizar un filtro
% pasabajos anal�gico de 2 orden. Se opt� por un mapeo continuo-digital
% basado en el teorema de muestreo, dado que, si bien el filtro no es
% estrictamente de banda limitada, se puede considerar que si lo es dada la
% gran atenuaci�n en alta frecuencia. Muestreando a una frecuncia de 16KHz,
% se deber�a esperar que entre 8KHz y 16KHz la respuesta en frecuencia del
% filtro original continuo sea despreciable frente a la amplitud de 8KHz
% para abajo. Dado que la m�xima frecuncia de resonancia utilizada en el 
% trabajo pr�ctico ser� de menos de 4KHz, esto se cumplir� siempre como se
% ve en la siguiente figura donde se grafic� para el caso l�mite.
%     **grafico de un espectro con fmax = 4KHz, resaltar atenuaci�n en 8KHz.
% 
% En primer lugar se busc� la respuesta al
% impulso del filtro antitransformando en Laplace H(s).
%     -H(s) -> h(t)
% con alfa=.. ,beta=... y gama=..
% Para obtener h(n) se muestre� h(t) como se explic� anteriormente
% Luego se calcul� la transformada Z de dicha funci�n, la cual es muy
% com�n y se encuentra en tablas:
%     H(Z) = ..
%     H(Z) = ..
% con A=.., B=.., C=...
% Finalmente teniendo en cuenta que 
%     H(Z) = Y(Z) / X(Z) = ...
% Se obtiene:
%     Y(Z) = ...X(Z)   (ec en dif en Z)
% Luego, antitransformando en Z se llega a la ecuaci�n en diferencias que
% ser� sumamente �til para implementar el filtro:
%     y(n) = ...

clear all;
% close all;

freq = linspace(0,16e3, 1000);

absH = abs(Hs_LP_2orden(i*freq*2*pi, .1, 2*pi*4000));
dbH = 20*log10(absH);

figure(1)
clf;
hold all;
plot(freq, dbH)
plot([8e3 8e3],[-25 15], 'r', 'Linewidth',1.5)
grid minor;
hold off;
title('Sistema Pasabajos de Segundo Orden.  (\omega_r = 2\pi4KHz)');
xlabel('Frecuencia [Hz]');
ylabel('Transferencia |H(s)|  [dB]');

% print('-dpng', '../Graficos/ej08_wr4KHz.png');