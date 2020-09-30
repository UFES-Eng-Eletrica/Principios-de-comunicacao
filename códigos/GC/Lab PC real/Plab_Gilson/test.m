clc;close all; clear all;

% ============================== Parametros ===============================

resol   = 8;        % Resolucao da amostra em [bits] (geralmente de 8 bits)
Rb      = 1e6;      % Taxa de sinalizacao (transmissao) em [bits/seg]
nsamp   = 4;        % Taxa de Oversampling (numero de vezes que se repete o bit a ser transmitido)
snr     = 9;        % SNR eh a relacao sinal-ruido em dB
n = 30000; % Numero de bits da Sequencia (Bitstream)
tp = 0; % 0-PAM, 1-PSK, 2-QAM
M = 2; %nível de modulacao
k = log2(M);       % bits por sÃ­mbolo

% Entrada do sistema
img_rgb = imread('foto_gcmf.jpg');    % Importa a imagem jpg em RGB

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

%% =========================== Parametros =================================
ti=0;
n=8; %numero de bits por amostras

%% ====================== discretizacao do audio ==========================

%leitura do audio
[x,Fs]=audioread('salerno.wav'); %audio estereo capturado
x=(x(:,1)); %capturando somente o mono

% Gerando o vetor tempo
dt= 1/Fs;                          % Periodo de amostragem                              
t= (ti:dt:(length(x)-1)*dt).';     % Gera o vetor tempo

N= 2^(n-1); %numero de pontos por amostra

quant= max(x)/(N-1); % Valor da quatizacao do sinal de voz

x_disc = ceil(x(:)/quant) ; % Sinal de audio discretizado

length(x_disc)
length(img_bin)