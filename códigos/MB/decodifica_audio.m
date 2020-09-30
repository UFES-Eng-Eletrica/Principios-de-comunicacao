function [saida] = decodifica_audio (entrada, n_bits_max, n_bits_div, resolucao, offset, canais)
% Decodifica o �udio proveniente de fun��es moduladoras do MATLAB, como 
% pskmod e qammod

% Entradas:
% entrada: sinal de �udio a ser decodificado.
% n_bits_max: n�mero de bits do �udio para codifica��o. N�o � utilizado a
%             resolu��o quando o audio tem mais de um canal.
% n_bits_div: log2(Numero_de_simbolos). N�o funciona para valores �mpares
% resolu��o: n�mero de bits por sample.
% offset: deslocamento vertical para que todos os valores sejam positivos.
% canais: n�mero de canais do �udio

% Os valores devem ser os mesmos da fun��o codifica_audio.

% Sa�das:
% saida: �udio decodificado, pronto para execu��o.

% Prealocamento de valores para acelerar o sistema.
tam = length(entrada)/n_bits_max*n_bits_div;
saida_t = char(ones(tam,n_bits_max));

% Transforma os valores recebidos em valores bin�rios.
entrada_bin = dec2bin(entrada);

% Processa s�mbolo a s�mbolo o sinal recebido
% Funcionamento: concatena os k s�mbolos de um sample de �udio e transforma
% o vetor resultante em decimal, e depois retira o offset e retorna os
% valores para a regi�o normalizada do �udio
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

% O �udio pode ter v�rios canais, e ele � separado a partir da rela��o de
% vetor de saida/vetor de entrada.
fim_de_curso = length(saida_t2)/canais;
k = 1;
saida = zeros(fim_de_curso, canais);
for i = 1:1:canais
   saida(:,i) = saida_t2(k:fim_de_curso*i,1); 
   k = k+fim_de_curso;
end

end