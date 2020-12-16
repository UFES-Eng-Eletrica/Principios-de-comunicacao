clc; close all; clear all

%% Carregando imagem
% read image from url (I took  a random  image on internet)..
img = imread('turtle.png');  %Lendo arquivo de imagem
img = imresize(img, [340 420]); % resize to a specific dimensions
img = rgb2gray(img);            %Convertendo imagem em escala de cinza   
figure, imshow(img), title ('Imagem em escala de cinza')

% Multiplexacao TDM em si

% Parametrizacao
M  = 2;             % Nivel de modulacao
k  = log2(M);       % bits por simbolo
nsamp  = 4;         % Taxa Oversampling (Qtd de pontos para representar o bit)
snr  = 30;          % SNR em dB
sinal_multiplexado = reshape(img,1,[]);
%sinal_multiplexado = img;

% Conversao A/D
fator_DC = max(abs(sinal_multiplexado)); % fator para garantir valores positivos
%sinal_multiplexado = sinal_multiplexado + fator_DC; % adiciona o fator
sinal_multiplexado = round(sinal_multiplexado);  % arredondamento para simular erro de quantizacao
sinal_multiplexado_digital = de2bi(sinal_multiplexado);   % converscao em si
[linhas,colunas] = size(sinal_multiplexado_digital);
%sinal_multiplexado_digital = sinal_multiplexado_digital(:); % transforma em vetor

% "Modulacao" PAM
xmod = pammod(sinal_multiplexado_digital,M);

% Convolucao com o filtro conformador
xmod_up = rectpulse(xmod,nsamp);
snrs = [-10:0.1:10];
bers = zeros(1,length(snrs));

for k = 1:length(snrs)
    snr = snrs(k);
% ++++++++++++++++++++++++++++  Canal +++++++++++++++++++++++++++++++++++
% Adiciona ruído Gaussiano branco ao sinal
y_ruido  = awgn(xmod_up,snr,'measured');

% ++++++++++++++++++++++++++++ Recepcao +++++++++++++++++++++++++++++++++++
%Demodulacao do Sinal
y = intdump(y_ruido, nsamp);      %
sinal_recebido = pamdemod(y, M);
[~, BER] = biterr(sinal_recebido, sinal_multiplexado_digital);
 bers(k) = BER;
end

sinal_recebido = bi2de(sinal_recebido);   % conversao em si
sinal_recebido = reshape(sinal_recebido, [340 420]);
sinal_recebido = uint8(sinal_recebido);   % converte double para int
%sinal_recebido = flip(sinal_recebido);

figure, plot(sinal_recebido);
imshow(sinal_recebido)

% sinal_1_recebido = sinal_recebido_aprox(1:2:2*tam);
% sinal_2_recebido = sinal_recebido_aprox(2:2:2*tam);
                                                                        

% ++++++++++++++++++++++++++++ Plotagem +++++++++++++++++++++++++++++++++++
%plot(xmod_up); hold on; plot(y_ruido); hold off;
%plot(snrs, 10*log10(bers))