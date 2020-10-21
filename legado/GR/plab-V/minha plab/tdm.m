%% Modulacao PAM com transmissao de 3 senoides com amplitudes diferentes
%
%%
clc; clear all; close all;
%% Definição dos parametros do sistema
ti = 0;             %tempo inicial
tf = 1e-6;          %tempo final
amostras = 1000;    %quantidade de posições no vetor
fat_amost = 10;     %fator de amostragem ( tem que ser > 2 )
A1 = 1;              %amplitude da senoide
A2 = 2;
A3 = 3;
n= 30000;
nbits = 8;          %transforma inteiro em 8 bits
M = 2; % Nível da modulação
k = log2(M); % bits por símbolo
nsamp = 4; % Taxa de Oversampling
Ebn0 = 20;          %energia do bit de ruido  em dB
Esn0 = Ebn0 + 10*log10(log2(M)); 
snr = Esn0 - 10*log10(nsamp) + 3;       % Vetor SNR em dB
Rb = 1e6;   %taxa de transmissão dos bits = 1Mbps
Tb = 1/Rb;  %periodo de transmisão
%% Criação do vetor tempo
ta = nbits*Tb;              %nbits é a quantidade de bits usados em de2bi
t = 0:ta:999*ta;
fa = 1/ta;
fmax = fa/fat_amost;        %frequencia maxima de amostragem
f1 = fmax/3;
f2 = fmax/2;
f3 = fmax;

% ===============  Leitura do Sinal de Audio ============================
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

%% Criação das senoides
s1 = A1*cos(2*pi*f1*t);           %vetor da senoide 1
s2 = A2*sin(2*pi*f2*t);         %vetor da senoide 2
s3 = A3*cos(2*pi*f3*t);         %vetor da senoide 3
%% Convers�o de cada senoide para decimal
quant1 = max(s1)/(2^7-1);            %quantizacao da senoide 1
y1 = round(s1/quant1);
signe1 = uint8((sign(s1)'+1)/2);      %bit do sinal
out1 = [signe1 de2bi(abs(y1),7)];
out1 = reshape(out1.',1,[]);        %senoide 1 serializada e convertida

quant2 = max(s2)/(2^7-1);            %quantizacao da senoide 2
y2 = round(s2/quant2);
signe2 = uint8((sign(s2)'+1)/2);      %bit do sinal
out2 = [signe2 de2bi(abs(y2),7)];
out2 = reshape(out2.',1,[]);        %senoide 2 serializada e convertida

quant3 = max(s3)/(2^7-1);            %quantizacao da senoide 3
y3 = round(s3/quant3);
signe3 = uint8((sign(s3)'+1)/2);      %bit do sinal
out3 = [signe3 de2bi(abs(y3),7)];
out3 = reshape(out3.',1,[]);        %senoide 3 serializada e convertida

%% Multiplexacao das tres senoides
cont = 1;
x = zeros(1,3*length(x));              % x é o vetor com as tres senoides
for ii = 1:length(x)
    x(cont) = out1(ii);
    x(cont+1) = out2(ii);
    x(cont+2) = out3(ii);
    cont = cont+3;
end

%&&&&&&&&&&&& Simulação do Sistema &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&%
%
disp('...................................................................')
disp('............... Modulação Digital .................................')
%
% ********************* TRANSMISSÃO ***************************************
%
% Modulacao (PAM-2)
M=4;
xmod = pskmod(x,M);

% Reamostragem (upsample)
x_up = rectpulse(xmod,nsamp);

% *********************** CANAL *******************************************
% Adiciona ruido Gaussiano branco ao sinal
y_ruido = awgn(x_up,snr,'measured');

% *************************************************************************


% ********************** RECEPCAO *****************************************
% Reamostragem (downsample)
y_down = intdump(y_ruido,nsamp);

% Demodulacao (M-PAM)
y = pskdemod(y_down,M); % Demapeamento

%% Demultiplexacao das tres senoides 
cont = 1;
for ii = 1:length(x)
    s1_final(ii) = y(cont);
    s2_final(ii) = y(cont+1);
    s3_final(ii) = y(cont+2);
    cont = cont + 3;
end
%------------------ CONVERTER PARA ANALOGICO------------------------------%
%Decodificar do Binario para decimal
mnovoquant2 = bi2de(vec2mat(y,8),'left-msb');


%Desquantizar o audio
m2 = (mnovoquant2*delta) + min(m);

%---------------------------GR�FICOS E ESPECTROS------------------------%
% Plotar o audio original
figure(1)
plot(t,m);
title('Sinal de Voz Original');

% Plotar o audio decodificado
figure(2)
plot(t,m2);
title('Sinal de Voz com Ruido');

[Sinal_ff,sinal_tf,f,df] = FFT_pot2(m.',dt); %Gera a FFT

%Plote no dominio da frequencia
figure(3)
plot(f,10*log10(fftshift(abs(Sinal_ff))));

xlabel('Frequencia [Hz]');
ylabel('Amplitude [dB]');
title('Sinal de Voz Original');
grid on;

[Sinal_ff2,sinal_tf2,f2,df2] = FFT_pot2(m2.',dt); %Gera a FFT

%Plote no dominio da frequencia
figure(4)
plot(f2,10*log10(fftshift(abs(Sinal_ff2))));

xlabel('Frequencia [Hz]');
ylabel('Amplitude [dB]');
title('Sinal de Voz com o Ruido');
grid on;

sound(m,Fs);% Sinal Original
pause(10);
sound(m2,Fs);
