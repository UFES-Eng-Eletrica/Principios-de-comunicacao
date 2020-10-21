%% LABORATORIO DA AULA 6
% Principios de Comunicoes I - Prof. Jair
% Aluno: Fabricio Henrique
% Transmissao em Banda Base com Modulação 2-PAM (NRZ bipolar) 
% PARA SINAL DE VOZ

clc, clear all, close all;
%
%...................... Parametros de Entrada .............................
M      = 4;           % Nivel da modulacao
n      = log2(M);     % bits por simbolo
nsamp  = 4;           % Taxa Oversampling (Qtd de pontos para representar o bit)
vsnr  = 10.8;          % Vetor SNR em dB


%&&&&&&&&&&&& Simulacao do Sistema &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
%
%
disp('...................................................................')
disp('............... Modulacao Digital .................................')
%

% ********************* TRANSMISSAO ***************************************
%

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

% Modulação (M-PSK)
xmod = pskmod(x,M);
    
% Convolucao com o filtro conformador
xmod = rectpulse(xmod,nsamp);


% *************** CANAL *******************************************
% Adapta o valor de SNR
snr = vsnr + 3 + 10*log10(n) - 10*log10(nsamp);

% Adiciona ruído Gaussiano branco ao sinal
y_ruido  = awgn(xmod,snr,'measured');


% ************** RECEPÇÃO *****************************************
% Convolucao com o filtro conformado na recepcao
y_ruido = intdump(y_ruido,nsamp);

% Demodulação (M-PSK) 
y = pskdemod(y_ruido,M);


%*********** Calcula os erros *************************************
d_bit = (abs(x-y));
n_erros = sum(d_bit);
ber = mean(d_bit);

% ********* Mostra Resultados Provisórios na Tela *********************
disp(sprintf('SNR: %4.1f dB BER: %5.1e N_erros: %7d', vsnr,ber,n_erros));

%------------------ CONVERTER PARA ANALOGICO------------------------------%
%Decodificar do Binario para decimal
mnovoquant2 = bi2de(vec2mat(y,8),'left-msb');
%Desquantizar o audio
m2 = (mnovoquant2*delta) + min(m);
%---------------------------GRÁFICOS E ESPECTROS------------------------%
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

% Obs: O BER para sinal de voz deve ser menor ou igual a 1x10^-3
% para isso SNR >= 6,8 dB