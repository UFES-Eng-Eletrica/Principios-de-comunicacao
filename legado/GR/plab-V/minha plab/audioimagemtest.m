
%% ======================= Parametros de Entrada ===========================

M      = 2;         % Nível da modulação
k      = log2(M);   % bits por símbolo
n      = 30000;     % Numero de bits da Sequencia (Bitstream)
nsamp  = 4;         % Taxa de Oversampling
ebn0   = 12;        % Associado com  SRN do sistema
tp     = 1;         % 0-PAM, 1-PSK, 2-QAM


A1     = 1;         % Ampitude do primeiro sinal a ser transmitido
A2     = 2;         % Ampitude do segundo sinal a ser transmitido
A3     = 3;         % Ampitude do terceiro sinal a ser transmitido

Rb     = 1e6;       % Taxa de bits a ser transmitido
ti     = 0;         % Tempo inicial
n      = 8;         % Numero de bits por amostras do sinal
tam_in = 100;       % Tamanho dos vetores de entrada (input)
rel    = 100;        % relacao_nyquist
N      = 2^(n-1);   %numero de pontos por amostra
%% ===============  Leitura do Sinal de Audio ============================
[m, Fs]   = audioread('Voz.wav');     % Carrega o sinal
% --------- Primeira parte - Calculos Preliminares ----------------------
dt        = 1/Fs;                          % Periodo de amostragem                              
t         = (0:dt:(length(m)-1)*dt).';     % Gera o vetor tempo
% ------------------------------------------------------------------------

Rs = Fs/2;


% Quantizacao (256 niveis)
a=max(max(m))-min(min(m)); %Diferenca entre o maximo e minimo valor de mnovo
delta= a/(256-1); %Valor da quantizacao dos degraus entre os niveis
z=(m-min(min(m)))/delta;
mnovoquant=round(z);

%Codificacao Binaria
binario=de2bi(mnovoquant,'left-msb');
x=binario';
x=x(:);
x=x';
audio = x;
%%  Entrada do sistema imagem
img_rgb = imread('foto3x4.jpg');    % Importa a imagem em RGB

% ============== Manipulacao da imagem para escala de cinza ===============

% Transformando a imagem em uma sequencia de bits
img_GS = rgb2gray(img_rgb); % Representa a imagem em escala de cinza

% Transforma a matriz da imagem (img_GS) de decimal para uma matriz em
% binario, onde cada linha representa um byte, pegando coluna por coluna de
% img_GS e colocando uma em baixo da outra
img_binMatrix = dec2bin((reshape(uint8(img_GS),[],1)).')-'0'; % colocar o -'0' coloca cada bit do byte em uma coluna


% Transforma a matriz de bits em um vetor de bits, colocando os bits de cada
% linha em sequencia
img_bin = reshape(img_binMatrix.',1,[]);

cont = 1;
x = zeros(1,3*length(img_bin));              % x é o vetor com as tres senoides
for ii = 1:length(img_bin)
    x(cont) = img_bin(ii);
    x(cont+1) = audio(ii);
    %x(cont+2) = (ii);
    cont = cont+2;
end
