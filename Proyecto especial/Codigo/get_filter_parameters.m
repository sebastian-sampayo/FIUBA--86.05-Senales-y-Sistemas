% Proyecto Especial
% Función para obtener los valores de xi y wr a partir de BW y wm.
%
% Uso:
% [fr, xi] = get_filter_parameters(fmax, BW, tolerance)

function [fr, xi] = get_filter_parameters(fmax, BW, tolerance)
minf = fmax/2;
maxf = fmax*2;
frequency = linspace(minf, maxf, 10000);
min_xi = BW/(2*fmax)/2;
max_xi = BW/(2*fmax)*2;
XIaprox = linspace(min_xi, max_xi , 10000);

    for j=1:length(XIaprox)
        fr = fmax./(sqrt(1-2*XIaprox(j).^2));
        absH = abs(Hs_LP_2orden(i*frequency*2*pi, XIaprox(j), fr*2*pi));
        dbH = 20*log10(absH);
        M = max(dbH);
        fm = frequency(find(dbH==M));
        nBW = find(dbH > M-3);
        BWaprox = frequency(nBW(end)) - frequency(nBW(1));
        error = abs(BWaprox/BW - 1); % Error relativo
        if error<tolerance
            xi = XIaprox(j);
            str = sprintf('f_max = %.5g | BW = %.5g Hz | fm = %.5gHz | BW_aprox = %.5g Hz | xi_aprox = %.3g', fmax, BW, fm, BWaprox, XIaprox(j));
            disp(str);
            break;
        end;
    end
end