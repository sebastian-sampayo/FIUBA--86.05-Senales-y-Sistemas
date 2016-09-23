% Proyecto Especial
% Ejercicio 6.

clear all;
close all;

% load frecuency_matrix.txt
% load BW_matrix.txt
fmax_matrix_in = csvread('mi_fmax.csv');
BW_matrix_in = csvread('mi_BW.csv');

tolerance = .01;
number_of_formants = size(fmax_matrix_in, 2);
fr_matrix_out = zeros(5, number_of_formants);
xi_matrix_out = zeros(5, number_of_formants);

for i=1:5
    for j=1:number_of_formants
        if fmax_matrix_in(i,j) == 0
            continue
        end
        [fr_matrix_out(i,j), xi_matrix_out(i,j)] = get_filter_parameters(fmax_matrix_in(i,j), BW_matrix_in(i,j), tolerance);
    end
end

% save f_matrix_out /ascii
% save xi_matrix_out /ascii
csvwrite('mi_fr.csv', fr_matrix_out);
csvwrite('mi_xi.csv', xi_matrix_out);