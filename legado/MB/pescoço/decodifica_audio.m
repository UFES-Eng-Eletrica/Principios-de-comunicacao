function [saida] = decodifica_audio (entrada, n_bits_max, n_bits_div, resolucao, offset)
% Decodifica o áudio proveniente de funções moduladoras do MATLAB, como 
% pskmod e qammod

% Entradas:
% entrada: sinal de áudio a ser decodificado.
% n_bits_max: número de bits do áudio para codificação. Não é utilizado a
%             resolução quando o audio tem mais de um canal.
% n_bits_div: log2(Numero_de_simbolos). Não funciona para valores ímpares
% resolução: número de bits por sample.
% offset: deslocamento vertical para que todos os valores sejam positivos.

% Os valores devem ser os mesmos da função codifica_audio.

% Saídas:
% saida: áudio decodificado, pronto para execução.

% Prealocamento de valores para acelerar o sistema.
tam = length(entrada)/n_bits_max*n_bits_div;
saida_t = zeros(tam,n_bits_max);
k = 1;

% Transforma os valores recebidos em valores binários.
entrada_bin = dec2bin(entrada);

% Processa símbolo a símbolo o sinal recebido
% Funcionamento: concatena os k símbolos de um sample de áudio e transforma
% o vetor resultante em decimal, e depois retira o offset e retorna os
% valores para a região normalizada do áudio
for i=1:n_bits_div:length(entrada)
    for j = 0:1:n_bits_div-1
        saida_t(k,1:(j+1)*n_bits_div) = strcat(char(saida_t(k,1:j*n_bits_div)),entrada_bin(i+j,1:n_bits_div));
    end
    k = k+1;
end
saida = bin2dec(char(saida_t))/(2^resolucao)-offset;
end