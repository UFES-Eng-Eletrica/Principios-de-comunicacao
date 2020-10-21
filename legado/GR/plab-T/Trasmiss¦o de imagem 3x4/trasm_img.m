%% ======= Trasmissao de uma imagem em escala cinza em um sistema PAM =======
%
% Transmitindo uma imagem em um sistema de comunicao digital utilizando modulacao PAM
%
% Rb - taxa de sinalizacao (transmissao) em [bits/seg]
% nsamp - %= 4;   Taxa de Oversampling (numero de vezes que se repete o bit a ser transmitido)
% snr - SNR eh a relacao sinal-ruido em dB
%

clc;close all; clear all;

% ============================== Parametros ===============================

resol   = 8;        % Resolucao da amostra em [bits] (geralmente de 8 bits)
Rb      = 1e6;      % Taxa de sinalizacao (transmissao) em [bits/seg]
nsamp   = 4;        % Taxa de Oversampling (numero de vezes que se repete o bit a ser transmitido)
snr     = 9;        % SNR eh a relacao sinal-ruido em dB
n = 30000; % Numero de bits da Sequencia (Bitstream)
tp = 0; % 0-PAM, 1-PSK, 2-QAM
M = 2; %n�vel de modulacao
k = log2(M);       % bits por símbolo

% Entrada do sistema
img_rgb = imread('foto3x4.jpg');    % Importa a imagem jpg em RGB

% ============== Manipulacao da imagem para escala de cinza ===============

% Transformando a imagem em uma sequencia de bits
img_GS = rgb2gray(img_rgb); % Representa a imagem em escala de cinza

% Transforma a matriz da imagem (img_GS) de decimal para uma matriz em
% binario, onde cada linha representa um byte, pegando coluna por coluna de
% img_GS e colocando uma em baixo da outra
img_binMatrix = dec2bin((reshape(uint8(img_GS),[],1)).')-'0'; % colocar o -'0'
%coloca cada bit do byte em uma coluna


% Transforma a matriz de bits em um vetor de bits, colocando os bits de cada
% linha em sequencia
img_bin = reshape(img_binMatrix.',1,[]);


% Envia a imagem ao sitema de comunicacao de acordo com a fun�ao
%Sist_modulacao_digital_PAM
[y,y_ruido] = Sist_modulacao_digital_PAM_QAM_e_PSK(img_bin,Rb,nsamp,snr,M,n,tp,k);

% Reorganiza o sinal recebido do sistema de comunicao de forma a colocar,
% em cada linha, cada byte recebido no receptor do sistema. (tem o mesmo
% papel da matriz 'img_binMatrix')
y_binMatrix = (reshape(y,resol,[])).';


% Transforma os valores de binario para decimal
y_binCol = bin2dec(char(y_binMatrix+'0'));

% Reorganiza o vetor com valores em decimal para uma matriz que representa
% a imagem original
[m,n] = size(img_GS); % Utilizado para informar as dimensoes da imagem
y_GS=reshape(uint8(y_binCol),m,n); % Matriz que representa a imagem recebida em escala de cinza


% ================================ Plots ==================================

figure(1)
imshow(img_GS)  % Plota a imagem original na escala de cinza

figure(2)
imshow(y_GS) % Plota a imagem recebida na escala de cinza

