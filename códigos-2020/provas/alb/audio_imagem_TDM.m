clc; close all; clear all

%% Carregando imagem
% read image from url (I took  a random  image on internet)..
img = imread('foto.png');  %Lendo arquivo de imagem
img = imresize(img, [340 420]); % resize to a specific dimensions
img = rgb2gray(img);           %Convertendo imagem em escala de cinza 
size_img = size(img);           %Guarda o formato da imagem
figure, imshow(img), title ('Imagem em escala de cinza')

% Parametrizacao
M  = 2;             % Nivel de modulacao
k  = log2(M);       % bits por simbolo 
nsamp  = 4;         % Taxa Oversampling (Qtd de pontos para representar o bit)
snr  = 30;          % SNR em dB
sinal_vetorizado = reshape(img,1,[]);
%sinal_multiplexado = img;

% Conversao A/D
sinal_vetorizado = round(sinal_vetorizado);  % arredondamento para simular erro de quantizacao
sinal_vetorizado_digital = de2bi(sinal_vetorizado);   % conversao em si
sinal_vetorizado_digital = sinal_vetorizado_digital';
sinal_vetorizado_digital = sinal_vetorizado_digital(:); % transforma em vetor
tam_img = length(sinal_vetorizado_digital);


%% Carregando audio 
[y_r, Fs_r] = audioread('sound.mp3'); % Lendo do arquivo de saida
% sound(y_r, Fs_r); %Ouvindo o audio salvo no aquivo

y_r = 100.*y_r;
% Conversão A/D
fator_DC = max(abs(y_r)); % fator para garantir valores positivos
y_r = y_r + fator_DC; % adiciona o fator
y_r = round(y_r);  % arredondamento para simular erro de quantização
y_r = de2bi(y_r);   % conversão em si
[linhas_audio,colunas_audio] = size(y_r);
y_r = y_r(:); % transforma em vetor

tam_audio = length(y_r);

%% Igualando os tamanhos dos vetores de imagem e audio 
tam = max(tam_audio,tam_img);
sinal_vetorizado_digital = [sinal_vetorizado_digital' zeros(1,tam-tam_img)];
y_r = [y_r' zeros(1,tam-tam_audio)];


% .......................... Transmissor ................................

sinal_mat = zeros(2,tam);   % inicializa vetor de transmissao com zeros

% Transforma os vetores dos dois sinais em um matriz 
for kk = 1:tam
  sinal_mat(1,kk) = sinal_vetorizado_digital(kk);      
  sinal_mat(2,kk) = y_r(kk);
end  

% Multiplexacao TDM em si
[linhas_m,colunas_m] = size(sinal_mat);
sinal_multiplexado = reshape(sinal_mat,1,2*tam);


%% "Modulacao" PAM
xmod = pammod(sinal_multiplexado,M);

% Convolucao com o filtro conformador
xmod_up = rectpulse(xmod,nsamp);
snrs = [-10:0.1:10];
bers = zeros(1,length(snrs));

% ++++++++++++++++++++++++++++  Canal +++++++++++++++++++++++++++++++++++
% Adiciona ruido Gaussiano branco ao sinal
y_ruido  = awgn(xmod_up,snr,'measured');

% ++++++++++++++++++++++++++++ Recepcao +++++++++++++++++++++++++++++++++++
%Demodulacao do Sinal
y = intdump(y_ruido, nsamp);      %
sinal_recebido = pamdemod(y, M);
[~, BER] = biterr(sinal_recebido, sinal_multiplexado);
%bers(k) = BER;
%end

sinal_recebido  = reshape(sinal_recebido, [linhas_m colunas_m]);

sinal_1_recebido = sinal_recebido(1,:);
sinal_2_recebido = sinal_recebido(2,:);

%% Recuperando Imagem
sinal_1_recebido = sinal_1_recebido(1, 1:tam_img);    %Pegando apenas os bits de imagem
sinal_1_recebido = reshape(sinal_1_recebido, 8, tam_img/8);       %Separando os bits de cada pixel
sinal_1_recebido = bin2dec(reverse(join(string(sinal_1_recebido'),''))); %Convertendo de binario para decimal
sinal_1_recebido = reshape(sinal_1_recebido, size_img);            %Reconstruindo imagem
sinal_1_recebido = uint8(sinal_1_recebido);   % converte double para int

figure, imshow(sinal_1_recebido)                   


%% Recuperando audio
sinal_2_recebido = sinal_2_recebido(1, 1:tam_audio);
sinal_2_recebido = reshape(sinal_2_recebido, [linhas_audio colunas_audio]);
sinal_2_recebido = bi2de(sinal_2_recebido); %Convertendo de binario para decimal
sinal_2_recebido = (sinal_2_recebido - fator_DC)./100;
