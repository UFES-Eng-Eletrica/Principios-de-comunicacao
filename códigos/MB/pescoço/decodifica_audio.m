function [saida] = decodifica_audio (entrada, n_bits_max, n_bits_div, resolucao, offset)
% Decodifica o �udio proveniente de fun��es moduladoras do MATLAB, como 
% pskmod e qammod

% Entradas:
% entrada: sinal de �udio a ser decodificado.
% n_bits_max: n�mero de bits do �udio para codifica��o. N�o � utilizado a
%             resolu��o quando o audio tem mais de um canal.
% n_bits_div: log2(Numero_de_simbolos). N�o funciona para valores �mpares
% resolu��o: n�mero de bits por sample.
% offset: deslocamento vertical para que todos os valores sejam positivos.

% Os valores devem ser os mesmos da fun��o codifica_audio.

% Sa�das:
% saida: �udio decodificado, pronto para execu��o.

% Prealocamento de valores para acelerar o sistema.
tam = length(entrada)/n_bits_max*n_bits_div;
saida_t = zeros(tam,n_bits_max);
k = 1;

% Transforma os valores recebidos em valores bin�rios.
entrada_bin = dec2bin(entrada);

% Processa s�mbolo a s�mbolo o sinal recebido
% Funcionamento: concatena os k s�mbolos de um sample de �udio e transforma
% o vetor resultante em decimal, e depois retira o offset e retorna os
% valores para a regi�o normalizada do �udio
for i=1:n_bits_div:length(entrada)
    for j = 0:1:n_bits_div-1
        saida_t(k,1:(j+1)*n_bits_div) = strcat(char(saida_t(k,1:j*n_bits_div)),entrada_bin(i+j,1:n_bits_div));
    end
    k = k+1;
end
saida = bin2dec(char(saida_t))/(2^resolucao)-offset;
end