% Proyecto Especial
% Ejercicio 8.

% Al informe:
% En este caso se busco la solución general para discretizar un filtro
% pasabajos analógico de 2 orden. Se optó por un mapeo continuo-digital
% basado en el teorema de muestreo, dado que, si bien el filtro no es
% estrictamente de banda limitada, se puede considerar que si lo es dada la
% gran atenuación en alta frecuencia. Muestreando a una frecuncia de 16KHz,
% se debería esperar que entre 8KHz y 16KHz la respuesta en frecuencia del
% filtro original continuo sea despreciable frente a la amplitud de 8KHz
% para abajo. Dado que la máxima frecuncia de resonancia utilizada en el 
% trabajo práctico será de menos de 4KHz, esto se cumplirá siempre como se
% ve en la siguiente figura donde se graficó para el caso límite.
%     **grafico de un espectro con fmax = 4KHz, resaltar atenuación en 8KHz.
% 
% En primer lugar se buscó la respuesta al
% impulso del filtro antitransformando en Laplace H(s).
%     -H(s) -> h(t)
% con alfa=.. ,beta=... y gama=..
% Para obtener h(n) se muestreó h(t) como se explicó anteriormente
% Luego se calculó la transformada Z de dicha función, la cual es muy
% común y se encuentra en tablas:
%     H(Z) = ..
%     H(Z) = ..
% con A=.., B=.., C=...
% Finalmente teniendo en cuenta que 
%     H(Z) = Y(Z) / X(Z) = ...
% Se obtiene:
%     Y(Z) = ...X(Z)   (ec en dif en Z)
% Luego, antitransformando en Z se llega a la ecuación en diferencias que
% será sumamente útil para implementar el filtro:
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