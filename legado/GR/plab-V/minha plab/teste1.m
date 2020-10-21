
clc;close all; clear all;
%% imagem
% ============================== Parametros ===============================
ebn0   = 12;        % Associado com  SRN do sistema
resol   = 8;        % Resolucao da amostra em [bits] (geralmente de 8 bits)
Rb      = 1e6;      % Taxa de sinalizacao (transmissao) em [bits/seg]
nsamp   = 4;        % Taxa de Oversampling (numero de vezes que se repete o bit a ser transmitido)
snr     = 9;        % SNR eh a relacao sinal-ruido em dB
n = 30000; % Numero de bits da Sequencia (Bitstream)
tp = 0; % 0-PAM, 1-PSK, 2-QAM
M = 2; %nível de modulacao
k = log2(M);       % bits por sÃ­mbolo

% Entrada do sistema
img_rgb = imread('foto3x4.jpg');    % Importa a imagem jpg em RGB
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

%% audio discretizado
% =========================== Parametros =================================
ti=0;
n=8; %numero de bits por amostras
% ====================== discretizacao do audio ==========================
%leitura do audio
[x,Fs]=audioread('audio.wav'); %audio estereo capturado
x=(x(:,1)); %capturando somente o mono

% Gerando o vetor tempo
dt= 1/Fs;                          % Periodo de amostragem                              
t= (ti:dt:(length(x)-1)*dt).';     % Gera o vetor tempo

N= 2^(n-1); %numero de pontos por amostra

quant= max(x)/(N-1); % Valor da quatizacao do sinal de voz

x_disc = ceil(x(:)/quant) ; % Sinal de audio discretizado
x_disc = abs(uint8(x_disc)).';
x_disc = reshape(dec2bin(x_disc),1,[]);
%% voz discretizada
% ====================== discretizacao do audio ==========================

%leitura da voz
[x,Fs]=audioread('vozplab.wav'); %audio estereo capturado
x=(x(:,1)); %capturando somente o mono

% Gerando o vetor tempo
dt= 1/Fs;                          % Periodo de amostragem                              
t= (ti:dt:(length(x)-1)*dt).';     % Gera o vetor tempo

N= 2^(n-1); %numero de pontos por amostra

quant= max(x)/(N-1); % Valor da quatizacao do sinal de voz

x_disc2 = ceil(x(:)/quant) ; % Sinal de audio discretizado
x_disc2 = abs(uint8(x_disc2)).';
x_disc2 = reshape(dec2bin(x_disc2),1,[]);


%senoide e cossenoide
A2     = 2;         % Ampitude do segundo sinal a ser transmitido
A3     = 3;         % Ampitude do terceiro sinal a ser transmitido

Rb     = 1e6;       % Taxa de bits a ser transmitido
ti     = 0;         % Tempo inicial
n      = 8;         % Numero de bits por amostras do sinal
tam_in = 100;       % Tamanho dos vetores de entrada (input)
rel    = 100;        % relacao_nyquist
N      = 2^(n-1);   %numero de pontos por amostra

%% ======================= SimulaÃ§Ã£o do Sistema ============================
%
snr=ebn0 + 10*log10(log2(M)) - 10*log10(nsamp) + 3; %calculo do SRN real do sistema 
disp('...................................................................')
disp('........................ Modulacao Digital ........................')
% ======================== Entradas do Sistema ============================
tb= 1/Rb;               % Periodo de um bit
ts= n*tb;               % Periodo de uma amostragemdo sinal
Fmax=1/ts;
%dt= ts;             % Periodo de amostragem do meu sinal






%% Multiplexacao dos três sinais
cont = 1;
x = zeros(1,1*length(img_bin));              % x Ã© o vetor com as tres senoides
for ii = 1:length(img_bin)
    x(cont) = img_bin(ii);
%    x(cont+1) = x_disc(ii);
 %   x(cont+2) = x_disc2(ii);
    cont = cont+1;
end

%%modulacao vem antes ou depois da multiplexação?
xmod=pammod(x, M);
%% reamostragem
% Reamostragem (upsample)
x_up = rectpulse(xmod,nsamp);
%% %#########################################################################
%############### Terceira Parte - Canal Ruidoso ##########################
y_ruido = awgn(x_up,snr,'measured');
%#########################################################################
%#########################################################################

%% ********************** RECEPÃ‡ÃƒO *****************************************
% Reamostragem (downsample)
y_down = intdump(y_ruido,nsamp);

%% Demodulacao (M-PAM)
y = pamdemod(y_down,M); % Demapeamento

%% ****** Quinta Parte - Demultiplexacao usando Filtro Passa Faixa *******
%h = fir1(ordem,[fcorte1 fcorte2]); % Cria o filtro passa banda
%figure(6), freqz(h,1,512) % Plota a resposta do filtro
%sinal_demux = filter(h,1,sinal_mux_ruidoso); % Filtra/demultiplexa


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

figure;
imshow(img_GS);
figure;
imshow(y_GS);

