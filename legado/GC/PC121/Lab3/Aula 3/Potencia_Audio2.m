% Principio de Comunicação - Aula 4.
% Wagner Trarbach Frank

% Inicializa��o
clc, clear all, close all

% ===============  Par�metros de Simula��o ==============================
snr     = 10;  % Rela��o Sinal-Ru�do

% ===============  Leitura do Sinal de Audio ============================
[m, Fs]   = audioread('audio48kHz.wav');     % Carrega o sinal

Fc        = Fs/4;     % Frequencia Central da Modula��o 

% =======================================================================

% --------- Primeira parte - Calculos Preliminares ----------------------
dt        = 1/Fs;                          % Periodo de amostragem                              
t         = (0:dt:(length(m)-1)*dt).';     % Gera o vetor tempo
% ------------------------------------------------------------------------

% Calcula os espectros dos sinais - pulso quadrado e pulso quadrado modulado 
[M,mn,f,df] = FFT_pot2(m.',dt);  % Determina o espectro

% Calcula potencia 

Xa = (m.^2);
Pn = (sum(abs(Xa)))/length(m);

% ........... Plota alguns Graficos ...................................... 
% Plota o sinal de mensagem m1 no dominio do tempo e da frequencia
figure(1)   % Figura referente ao sinal de audio no tempo
subplot(2,1,1)
plot(t,m,'b'), grid, 
title ('Sinal de Audio'); xlabel('tempo [s]'), ylabel('ampl. [u.a.]')
axis tight

subplot(2,1,2), plot(f,10*log10(fftshift(abs(M))),'b'), grid
title ('Espectro de Poténcia em Banda Base');
xlabel('Frequencia[Hz]'), ylabel('PSD [dB/Hz]'), axis tight

plot(t,Pn);