% Proyecto Especial
% Ejercicio 8. -warping-

clear all;
close all;

Fs = 16e3;
wm = 2*pi*4000;
wm2 = 2*Fs*tan(wm/(2*Fs));

w = linspace(0, 2*pi*Fs, 1000);
om = 2*atan(w/(2*Fs));

hold all;
plot(w, om,'Linewidth',2)
plot(w, w/Fs,'Linewidth',2)
plot(w, pi,'.-k','Linewidth',2)
% plot(w, -pi,'k')
plot([wm wm], [0 wm/Fs],'--r')
plot([wm2 wm2], [0 2*atan(wm2/(2*Fs))],'--r')
plot(w(1:320), wm/Fs, '--r')

text(.1e4,pi+.15,'\fontsize{15}\pi')
text(wm-.1e4, -0.1, '\fontsize{12}\omega_m')
text(wm2, -0.1, '\fontsize{12}\omega''_m')
text(0, wm/Fs+.1, '\fontsize{14}\Omega_m')

axis([0 1e5 0 4])
xlabel('\omega')
ylabel('\Omega')
legend('\Omega = 2atan(\omega/(2Fs))', '\Omega = \omega/Fs')
title('Relación entre \omega y \Omega')
% Warping en Transformación Bilineal
grid on

print('-dpng', '../Graficos/ej08_warping.png');