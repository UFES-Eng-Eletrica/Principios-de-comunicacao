function [saida] = decodifica_audio (entrada, n_bits_max, n_bits_div, resolucao, offset, canais)
% Decodifica o áudio proveniente de funções moduladoras do MATLAB, como 
% pskmod e qammod

% Entradas:
% entrada: sinal de áudio a ser decodificado.
% n_bits_max: número de bits do áudio para codificação. Não é utilizado a
%             resolução quando o audio tem mais de um canal.
% n_bits_div: log2(Numero_de_simbolos). Não funciona para valores ímpares
% resolução: número de bits por sample.
% offset: deslocamento vertical para que todos os valores sejam positivos.
% canais: número de canais do áudio

% Os valores devem ser os mesmos da função codifica_audio.

% Saídas:
% saida: áudio decodificado, pronto para execução.

% Prealocamento de valores para acelerar o sistema.
tam = length(entrada)/n_bits_max*n_bits_div;
saida_t = char(ones(tam,n_bits_max));

% Transforma os valores recebidos em valores binários.
entrada_bin = dec2bin(entrada);

% Processa símbolo a símbolo o sinal recebido
% Funcionamento: concatena os k símbolos de um sample de áudio e transforma
% o vetor resultante em decimal, e depois retira o offset e retorna os
% valores para a região normalizada do áudio
k = 1;
for i=1:n_bits_max/n_bits_div:length(entrada)
    a = entrada_bin(i,1:n_bits_div);
    for j = 1:1:n_bits_max/n_bits_div-1
            b = entrada_bin(i+j,1:n_bits_div);
            a = strcat(a,b);
    end
    saida_t(k,:) = a;
    k = k+1;
end
saida_t2 = bin2dec(char(saida_t))/(2^resolucao)-offset;

% O áudio pode ter vários canais, e ele é separado a partir da relação de
% vetor de saida/vetor de entrada.
fim_de_curso = length(saida_t2)/canais;
k = 1;
saida = zeros(fim_de_curso, canais);
for i = 1:1:canais
   saida(:,i) = saida_t2(k:fim_de_curso*i,1); 
   k = k+fim_de_curso;
end

end