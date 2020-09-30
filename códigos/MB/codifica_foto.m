function [saida, fim_de_curso] = codifica_foto (entrada, n_bits_max, n_bits_div)

tam = length(entrada(:,:,1))*length(entrada(:,:,1)');
sinal_bin = char(ones(tam, n_bits_max,3));

% sinal_bin(:,:,1) = dec2bin(entrada(:,:,1), n_bits_max); 
% sinal_bin(:,:,2) = dec2bin(entrada(:,:,2), n_bits_max); 
% sinal_bin(:,:,3) = dec2bin(entrada(:,:,3), n_bits_max); 

k = 1;
tam = length(sinal_bin)*3*n_bits_max/n_bits_div;
saida = zeros(tam, 1);

for i = 1:1:length(sinal_bin)
    for j = 1:n_bits_div:n_bits_max
        valor = sinal_bin(i,j:j+n_bits_div-1);
        valor_bin = bin2dec(valor);
        saida(k) = valor_bin;
        k = k+1;
    end
end

fim_de_curso = length(saida)/(length(entrada)*(n_bits_max/n_bits_div));

end