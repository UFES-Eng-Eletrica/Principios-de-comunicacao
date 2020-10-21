% ======================= Parametros de Entrada ===========================

M      = 2;         % Nível da modulação
k      = log2(M);   % bits por símbolo
%n      = 30000;     % Numero de bits da Sequencia (Bitstream)
nsamp  = 4;         % Taxa de Oversampling
ebn0   = 12;        % Associado com  SRN do sistema
tp     = 0;         % 0-PAM, 1-PSK, 2-QAM


A1     = 1;         % Ampitude do primeiro sinal a ser transmitido
A2     = 2;         % Ampitude do segundo sinal a ser transmitido
A3     = 3;         % Ampitude do terceiro sinal a ser transmitido

Rb     = 1e6;       % Taxa de bits a ser transmitido
ti     = 0;         % Tempo inicial
n      = 8;         % Numero de bits por amostras do sinal
tam_in = 100;       % Tamanho dos vetores de entrada (input)
rel    = 100;        % relacao_nyquist
N      = 2^(n-1);   %numero de pontos por amostra


%% Entrada do sistema
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

%% leitura do audio
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

%% senoide e cossenoide
A2     = 2;         % Ampitude do segundo sinal a ser transmitido
A3     = 3;         % Ampitude do terceiro sinal a ser transmitido

Rb     = 1e6;       % Taxa de bits a ser transmitido
ti     = 0;         % Tempo inicial
n      = 8;         % Numero de bits por amostras do sinal
tam_in = 100;       % Tamanho dos vetores de entrada (input)
rel    = 100;        % relacao_nyquist
N      = 2^(n-1);   %numero de pontos por amostra

%% ======================= Simulação do Sistema ============================
%
snr=ebn0 + 10*log10(log2(M)) - 10*log10(nsamp) + 3; %calculo do SRN real do sistema 
disp('...................................................................')
disp('........................ Modulacao Digital ........................')
% ======================== Entradas do Sistema ============================
tb= 1/Rb;               % Periodo de um bit
ts= n*tb;               % Periodo de uma amostragemdo sinal
Fmax=1/ts;
dt= ts;             % Periodo de amostragem do meu sinal


t = (ti:ts:tam_in*ts).';     % Gera o vetor tempo
f3 = Fmax/rel;

%relacao pedida pelo professor
f1 = f3/3;
f2 = f1*2;

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
for cont=1:length(3*img_bin)
    Input_dec=[Input_decimg_bin(cont) I2(cont) I3(cont)];
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


Out1_bin=[];
Out2_bin=[];
Out3_bin=[];

for cont=1:length(y)/8-1
    if(rem(cont,3)==0)
        Out1_bin=[Out1_bin y((cont*8+1):(cont*8+n))];
    end
    if(rem(cont,3)==1)
        Out2_bin=[Out2_bin y((cont*8+1):(cont*8+n))];
    end
    if(rem(cont,3)==2)
        Out3_bin=[Out3_bin y((cont*8+1):(cont*8+n))];
    end
end




% y_binMatrix=(reshape(y,n,[])).';
% 
% 
% y_binCol = bin2dec(char(y_binMatrix+'0'));
% 
% [num_linhas,num_colunas]=size(y_binMatrix);
% 
% for cont=1:num_linhas
%     if(y_binMatrix(cont,1) ==1)
%         Out1_bin(cont,1)=0;
%         Out1=[Out1 -1*bin2dec(char(Out1_bin(cont,:)+'0'))];
%     else
%         Out1=[Out1 bin2dec(char(Out1_bin(cont,:)+'0'))];
%     end
% end



Out1_bin = (reshape(Out1_bin,n,[])).';
Out2_bin = (reshape(Out2_bin,n,[])).';
Out3_bin = (reshape(Out3_bin,n,[])).';

Out1=[];
Out2=[];
Out3=[];


% Transforma os valores de binario para decimal, mas ainda quantizados
for cont=1:length(Out1_bin)
    if(Out1_bin(cont,1) == 1)
        Out1_bin(cont,1)=0;
        Out1=[Out1 -1*bin2dec(char(Out1_bin(cont,:)+'0'))];
    else
        Out1=[Out1 bin2dec(char(Out1_bin(cont,:)+'0'))];
    end
    
    if(Out2_bin(cont,1) ==1)
        Out2_bin(cont,1)=0;
        Out2=[Out2 -1*bin2dec(char(Out2_bin(cont,:)+'0'))];
    else
        Out2=[Out2 bin2dec(char(Out2_bin(cont,:)+'0'))];
    end
    
    if(Out3_bin(cont,1) ==1)
        Out3_bin(cont,1)=0;
        Out3=[Out3 -1*bin2dec(char(Out3_bin(cont,:)+'0'))];
    else
        Out3=[Out3 bin2dec(char(Out3_bin(cont,:)+'0'))];
    end 
end

Out1=Out1*quant;
Out2=Out2*quant;
Out3=Out3*quant;

