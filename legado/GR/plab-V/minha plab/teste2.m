% ======================= Parametros de Entrada ===========================

M      = 2;         % Nível da modulação
k      = log2(M);   % bits por símbolo
%n      = 30000;     % Numero de bits da Sequencia (Bitstream)
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



%% ======================= Simulação do Sistema ============================
%
snr=ebn0 + 10*log10(log2(M)) - 10*log10(nsamp) + 3; %calculo do SRN real do sistema 
disp('...................................................................')
disp('........................ Modulacao Digital ........................')
% ======================== Entradas do Sistema ============================
tb= 1/Rb;               % Periodo de um bit
ts= n*tb;               % Periodo de uma amostragemdo sinal
Fmax=1/ts;
%dt= ts;             % Periodo de amostragem do meu sinal


t = (ti:ts:tam_in*ts).';     % Gera o vetor tempo
f3 = Fmax/rel;

%relacao pedida pelo professor
f1 = f3/3;
f2 = f1*2;

%I1 = img_bin;
I1=A1*cos(2*pi*f1*t);     %Input 1
I2=A2*cos(2*pi*f2*t);     %Input 2
I3=A3*sin(2*pi*f3*t);     %Input 3

% =========================== TRANSMISS�O =================================

%quant= max([I1 I2 I3])/(N-1); % Valor da quatizacao do sinal de entrada

if ((max(I1)>= max(I2))&&(max(I1)>= max(I3)))
    quant= max(I1)/(N-1);
elseif((max(I2)>= max(I1))&&(max(I2)>= max(I3)))
    quant= max(I2)/(N-1);
elseif((max(I3)>= max(I2))&&(max(I3)>= max(I1)))
    quant= max(I3)/(N-1);
end

% multiplexacao dos sinais de entrada
Input_dec=[];%gera o vetor multiplexado, mas em decimal
for cont=1:length(img_bin)
    Input_dec=[Input_dec img_bin(cont) I2(cont) I3(cont)];
end

x = ceil(Input_dec(:)/quant) ; % Discretiza o sinal multiplexado

% Transforma a matriz da imagem (img_GS) de decimal para uma matriz em
% binario, onde cada linha representa um byte, pegando coluna por coluna de
% img_GS e colocando uma embaixo da outra

x_bin=[];
for cont= 1:length(x)
    if(x(cont)< 0)
        num_bin=dec2bin(abs(x(cont)),n);
        num_bin(1)='1';
    else
        num_bin=dec2bin(x(cont),n);
    end
    x_bin=[x_bin num_bin];
end

x_bin=x_bin-'0';
x_bin= reshape(x_bin.',1,[]);

img_binMatrix = dec2bin((reshape(uint8(img_GS),[],1)).')-'0'; % colocar o -'0' coloca cada bit do byte em uma coluna

% Transforma a matriz de bits em um vetor de bits, colocando os bits de cada
% linha em sequencia
img_bin = reshape(img_binMatrix.',1,[]);

% Gera o Bitstream
%x = randi([0, M-1], 30000, 1);


% Modulacao
if tp == 0
        % Modulação (M-PAM)
        xmod = pammod(x_bin,M);     % mapeamento
else if tp == 1
    % Modulação (M-PSK)
        xmod  = pskmod(x_bin,M);    % mapeamento
else
    % Modulação (M-QAM)
    xmod  = qammod(x_bin,M);    % mapeamento
    end
end
% Reamostragem (upsample)
x_up = rectpulse(xmod,nsamp);
% ***************************** CANAL *************************************
% Adiciona ruído Gaussiano branco ao sinal
y_ruido = awgn(x_up,snr,'measured');
% ********************** RECEPÇÃO *****************************************
% Reamostragem (downsample)
y_down = intdump(y_ruido,nsamp);
% Demodulação
if tp == 0
    % Demodulação (M-PAM)
    y = pamdemod(y_down,M);  % Demapeamento
else if tp == 1
    % Demodulação (M-PSK)
    y = pskdemod(y_down,M);  % Demapeamento
else
    % Demodulação (M-QAM)
    y = qamd;
    emod(y_down,M);          % Demapeamento
    end
end

