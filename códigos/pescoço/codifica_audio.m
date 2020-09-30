function [saida] = codifica_audio (entrada, n_bits_max, n_bits_div, resolucao, offset)
% Codifica o áudio em formato compatível com funções moduladoras do MATLAB,
% como pskmod e qammod

% Entradas:
% entrada: sinal de áudio a ser codificado.
% n_bits_max: número de bits do áudio para codificação. Não é utilizado a
%             resolução quando o audio tem mais de um canal.
% n_bits_div: log2(Numero_de_simbolos). Não funciona para valores ímpares
% resolução: número de bits por sample.
% offset: deslocamento vertical para que todos os valores sejam positivos.

% Saídas:
% saida: áudio codificado em formato compatível com funções moduladoras do
% MATLAB.

% Aplica o offset no audio, transforma em números inteiros cada sample e
% converte para binário para realizar o processamento.
sinal_bin = dec2bin((entrada+offset)*(2^resolucao), n_bits_max); 

% Prealocamento de valores para acelerar o processamento.
k = 1;
tam = length(sinal_bin)*n_bits_max/n_bits_div;
saida = zeros(tam, 1);

% Processa sample a sample o audio.
% Funcionamento: divide o sample em várias partes e recombina em um único
% vetor de valores inteiros com range [0, M-1].
for i = 1:1:length(sinal_bin)
    for j = 1:n_bits_div:n_bits_max
        valor = sinal_bin(i,j:j+n_bits_div-1);
        valor_bin = bin2dec(valor);
        saida(k) = valor_bin;
        k = k+1;
    end
end
end

