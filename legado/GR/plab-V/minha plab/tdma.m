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
%% Criação das senoides
s1 = A1*sin(2*pi*f1*t);           %vetor da senoide 1
s2 = A2*cos(2*pi*f2*t);         %vetor da senoide 2
s3 = A3*sin(2*pi*f3*t);         %vetor da senoide 3
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

% ===============  Leitura do Sinal de Audio ============================
[m, Fs]   = audioread('vozplab.wav');     % Carrega o sinal
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

%% Multiplexacao das tres senoides
cont = 1;
%x = zeros(1,length(x_disc2));              % x é o vetor com as tres senoides
x = zeros(1, 3*length(x));
for ii = 1:length(x)
    x(cont) = x(ii);
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
xmod = pammod(x,M);

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
y = pamdemod(y_down,M); % Demapeamento

%% Demultiplexacao das tres senoides 
cont = 1;
for ii = 1:8000
    s1_final(ii) = y(cont);
    s2_final(ii) = y(cont+1);
    s3_final(ii) = y(cont+2);
    cont = cont + 3;
end
%% Conversao binario para decimal

s1_final_bin = reshape(s1_final,8,[]);
s2_final_bin = reshape(s2_final,8,[]);
s3_final_bin = reshape(s3_final,8,[]);

s1_final_bin = s1_final_bin.';
s2_final_bin = s2_final_bin.';
s3_final_bin = s3_final_bin.';

s1_final_bin(:,1) = 0;             %remove a primeira coluna do sinal
s2_final_bin(:,1) = 0;
s3_final_bin(:,1) = 0;

signe1 = changem(double(signe1),-1,0);
signe2 = changem(double(signe2),-1,0);
signe3 = changem(double(signe3),-1,0);

s1_final_dec = signe1.*bi2de(s1_final_bin);
s2_final_dec = signe2.*bi2de(s2_final_bin);
s3_final_dec = signe3.*bi2de(s3_final_bin);


%% Desquantizacao
y1_final = s1_final_dec.*quant1/2;
y2_final = s2_final_dec.*quant2/2;
y3_final = s3_final_dec.*quant3/2;
%**************************************************************************
% ******************* Calcula os erros ************************************* 
d_bit = (abs(x-y));
n_erros = sum(d_bit);
ber_awgn = mean(d_bit);

%************** Mostra Resultados Provisórios na Tela *********************
%
fprintf('SNR: %4.1f dB\n',snr);
fprintf('BER: %5.1e \n',ber_awgn);
fprintf('Qtd de erros: %3d\n',n_erros);
%
disp('...................................................................')

%% ------------------------ Mostra alguns Gráficos ------------------------
% Plota os sinais no dominio do Tempo
figure
plot(real(x_up(1:nsamp*50))) % plota o sinal modulado
hold on
plot(real(y_ruido(1:nsamp*50)),'r') % plota o sinal ruidoso

% Mostra o diagram de olho na saída do canal
if nsamp == 1
 offset = 0;
 h = eyediagram(real(y_down),2,1,offset);
else
 offset = 2;
 h = eyediagram(real(y_down),3,1,offset);
end
set(h,'Name','Diagram de Olho sem Offset');

% Mostra o Diagrama de Constelação
scatterplot(y_down)

% % Mostra o sinal enviado e o sinal recebido
% figure()
% plot(t,s1,t,s2,t,s3);
% axis([0 0.002 -4 4])
% title('Sinal enviado');
% 
% figure()
% plot(t,y1_final,t,y2_final,t,y3_final);
% axis([0 0.002 -4 4])
% title('Sinal recebido')
figure()
subplot(2,1,1);
plot(t,s1);
title('Sinal enviado');

subplot(2,1,2);
plot(t,y1_final);
title('Sinal recebido');




%% Cálculo e plot do espectro do sinal
[Sinal_ff,sinal_tf,f,df] = FFT_pot2(x_up,Tb);
% [Sinal2_ff,sinal2_tf,f,df] = FFT_pot2(y_ruido',(n/Rb));
figure();
plot(f,10*log(fftshift(abs(Sinal_ff))),'r');
% hold on;
% plot(f,10*log(fftshift(abs(Sinal2_ff))),'b');
grid on;
xlabel('Frequência (Hz)');
ylabel('Amplitude(dBm/Hz)');
title('Espectro do Sinal Modulado');
legend('Sinal de entrada','Sinal de entrada com ruido');
%%

