%% Modulacao PAM com transmissao de 3 senoides com amplitudes diferentes
%
%%
clc; clear all; close all;
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
s1 = A1*sin(2*pi*f1*t);           %vetor da senoide 1
%s2 = A2*sin(2*pi*f2*t);         %vetor da senoide 2
%s3 = A3*sin(2*pi*f3*t);         %vetor da senoide 3
%% ConversÁ„o de cada senoide para decimal
quant1 = max(s1)/(2^7-1);            %quantizacao da senoide 1
y1 = round(s1/quant1);
signe1 = uint8((sign(s1)'+1)/2);      %bit do sinal
out1 = [signe1 de2bi(abs(y1),7)];
out1 = reshape(out1.',1,[]);        %senoide 1 serializada e convertida