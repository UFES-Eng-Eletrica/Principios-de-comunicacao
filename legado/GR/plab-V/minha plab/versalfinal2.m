

%% ...................... Parametros de Entrada .............................
M = 4; % NÌvel da modulaÁ„o
k = log2(M); % bits por sÌmbolo = log2(M)=1
n = 30000; % Numero de bits da Sequencia (Bitstream)
nsamp = 4; % Taxa de Oversampling
snr = 7.88; % Vetor SNR em dB
tp = 0; % 0-PAM, 1-PSK, 2-QAM


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

%% s
% ===============  Leitura do Sinal de Audio ============================
[m, Fs]   = audioread('audio48kHz.wav');     % Carrega o sinal

Fc        = Fs/4;     % Frequencia Central da ModulaÁ„o 

% =======================================================================

% --------- Primeira parte - C·lculos Preliminares ----------------------
dt        = 1/Fs;                          % Periodo de amostragem                              
t         = (0:dt:(length(m)-1)*dt).';     % Gera o vetor tempo
% ------------------------------------------------------------------------

% -- Segunda Parte: GeraÁ„o do Sinal e o Correspondente defasado de 90∞ --
s_hil = hilbert(m);    % Sinal com transformada de Hilbert

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

%% entrada do terceiro sinal , que È senoidal ou cossenoidal
ta  = 1/Fs;            % Periodo de amostragem dos sinais em banda base
tam = 2048;            % Tamanho dos vetores 
t  = (0:ta:tam*ta).';  % Cria o novo vetor tempo j? em banda passante

% --------- Primeira parte - Gera os sinais a serem multiplexados --------
% Sinal em Banda Base (Fonte I)
%fc1 = 1000;             % Frequencia central do primeiro sinal (Banda Base)
%s1  = sin(2*pi*fc1*t);  % primeiro sinal a ser multiplexado 


%% Defini√ß√£o dos parametros do sistema
ti = 0;             %tempo inicial
tf = 1e-6;          %tempo final
amostras = 1000;    %quantidade de posiÁıes no vetor
fat_amost = 10;     %fator de amostragem ( tem que ser > 2 )
A1 = 1;              %amplitude da senoide
A2 = 2;
A3 = 3;

nbits = 8;          %transforma inteiro em 8 bits
M = 2; % N√≠vel da modula√ß√£o
k = log2(M); % bits por s√≠mbolo
nsamp = 4; % Taxa de Oversampling
Ebn0 = 20;          %energia do bit de ruido  em dB
Esn0 = Ebn0 + 10*log10(log2(M)); 
snr = Esn0 - 10*log10(nsamp) + 3;       % Vetor SNR em dB
Rb = 1e6;   %taxa de transmiss√£o dos bits = 1Mbps
Tb = 1/Rb;  %periodo de transmis√£o
%% Cria√ß√£o do vetor tempo
ta = nbits*Tb;              %nbits √© a quantidade de bits usados em de2bi
t = 0:ta:999*ta;
fa = 1/ta;
fmax = fa/fat_amost;        %frequencia maxima de amostragem
f1 = fmax/3;
f2 = fmax/2;
f3 = fmax;
%% CriaÁ„o das senoides
s1 = A1*cos(2*pi*f1*t);           %vetor da senoide 1
%s2 = A2*sin(2*pi*f2*t);         %vetor da senoide 2
%s3 = A3*sin(2*pi*f3*t);         %vetor da senoide 3
%% ConversÁ„o de cada senoide para decimal
quant1 = max(s1)/(2^7-1);            %quantizacao da senoide 1
y1 = round(s1/quant1);
signe1 = uint8((sign(s1)'+1)/2);      %bit do sinal
out1 = [signe1 de2bi(abs(y1),7)];
out1 = reshape(out1.',1,[]);        %senoide 1 serializada e convertida
out1=round(out1*(M-1));
%% outra multiplexaÁ„o


%% TDM

img_m = [img_bin;zeros((length(audio)-length(img_bin)),1)];
audio_m = [audio;zeros((length(audio)-length(audio)),1)];
out1_m = [out1;zeros((length(audio)-length(out1)),1)];

img_bin = upsample(img_bin,3);
audio = upsample(audio,3,1);
out1 = upsample(out1,3,2);
Ftx = img_bin+out1+audio;
Ftx_bit = rectpulse(Ftx,nsamp);
%% CANAL

Fruido = awgn(Ftx_bit,SNR,'measured');
%% DE-TDM

Frx_bit = intdump(Fruido,nsamp);
Irx = downsample(Frx_bit,3);
Vrx = downsample(Frx_bit,3,1);
Arx = downsample(Frx_bit,3,2);
%% mostragem da imagem
y_bin1 = reshape(img_final,8,[]);
y_bin1 = y_bin1.';
y_dec1 = bi2de(y_bin1);
% figure;                                       % figura 2
imag_demod = uint8(y_dec1);              % transforma para inteiro 
[imagem_demod,paded] = vec2mat(imag_demod,tam_y1); % transforma em matriz
imshow(imagem_demod);

%% *********** Calcula os erros *************************************
d_bit = (abs(x-y));
n_erros = sum(d_bit);
ber = mean(d_bit);

%% CONVERTER audio para ANALOGICO--%
%Decodificar do Binario para decimal
mnovoquant2 = bi2de(vec2mat(y,8),'left-msb');
%Desquantizar o audio
m2 = (mnovoquant2*delta) + min(m);
%sound(m2,Fs);% Sinal Original
%pause(10);
%sound(m2,Fs);
% Mostra o diagram de olho na sa√≠da do canal
if nsamp == 1
    offset = 0;
    h =  eyediagram(real(y_down),2,1,offset);
else
    offset = 2;
    h =  eyediagram(real(y_down),3,1,offset);
end

set(h,'Name','Diagram de Olho sem Offset');


% Mostra o Diagrama de Constela√ß√£o
scatterplot(y_down)
