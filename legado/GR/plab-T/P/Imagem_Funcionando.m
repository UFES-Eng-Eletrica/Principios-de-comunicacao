%
clc, clear all, close all;
%

%...................... Parametros de Entrada .............................
M      = 2;           % Nível da modulação
m      = log2(M);     % bits por símbolo
n      = 3000;        % Numero de bits da Sequencia (Bitstream)
nsamp  = 4;           % Taxa de Oversampling // superamostra o sinal
snr    = 1;           % Signal Noise Ratio in dB
Fa     = 10.0e6;      %Taxa de amostragem//sinalizacao
ta     = 1/Fa;        %Periodo do Bit
Rs     = Fa/m;        %Numero de Simbolos

% ********************* TRANSMISSÃO ***************************************
imagem_in=imread('Foto.jpg');%Leitura da Imagem
imagem_in=rgb2gray(imagem_in); %passa para a escala de cinza
matriz_in=imagem_in(:); %transforma em um vetor coluna
matriz_bin = de2bi(matriz_in); %passa de decimal para binario,a funcao de2bi n retorna binario em forma de string como a dec2bin
matriz_bin=matriz_bin(:); %transforma em um vetor coluna  
x =matriz_bin; %variavel auxiliar
xmod  = pammod(x,M); % Modulação (M-PAM)   
x_up = rectpulse(xmod,nsamp); % Reamostragem (upsample)
% Adiciona ruído Gaussiano branco ao sinal
y_ruido = awgn(x_up,snr,'measured');


% ********************** RECEPÇÃO ****************************** ***********
y_down = intdump(y_ruido,nsamp); % Reamostragem (downsample)
y = pamdemod(y_down,M); % Demodulação   

% Demapeamento
y=reshape(y,[],8); %transformamos o vetor coluna em uma matriz
y_in=uint8(bi2de(y)); %junta os bits das oito colunas e transforma de binario para decimal, o resultado final e um vetor coluna decimal
imagem_out=reshape(y_in,[],size(imagem_in,2)); %rearranja a matriz de forma a ficar igual a inicial
imshow(imagem_out); %mostra a imagem
imwrite(imagem_out,'teste.tif'); %salva a imagem 
