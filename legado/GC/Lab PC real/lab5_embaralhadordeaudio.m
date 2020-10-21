%                                                                         %
% =========================================================================
%                                                                         %
%                    - Principios Comunica??es I -                        %
%    ----------  Embaralhador e Desembaralhador de A?dio   -------------  %
%          ......... Com um sinal de Audio   ............                 %
%                                                                         %
% by Prof. Jair Silva                                                     %
%                                                                         %
% =========================================================================

% Inicializa??o
clc, clear all, close all


% ===============  Par?metros de Simula??o ==============================
Fc      = 15e3;     % Frequencia Central da Modula??o 
snr     = 100;      % Rela??o Sinal-Ru?do

% ===============  Leitura do Sinal de Audio ============================
[m, Fs]   = audioread('audio48kHz.wav');     % Carrega o sinal
                                           % Compare Fs com Fc
% =======================================================================

% --------- Primeira parte - C?lculos Preliminares ----------------------
dt        = 1/Fs;                          % Periodo de amostragem                              
t         = (0:dt:(length(m)-1)*dt).';     % Gera o vetor tempo
% fc1 = 1000;             % Frequencia central do primeiro sinal (Banda Base)
% m  = sin(2*pi*fc1*t);   % primeiro sinal a ser multiplexado 
% ------------------------------------------------------------------------

% ---------- Segunda Parte: Modula o Sinal de ?udio  ---------------------
s = ssbmod(m,Fc,Fs);                     % Modula o sinal de Audio
                                         % O Filtro passa baixa ?
                                         % implementado internamente 
% ------------------------------------------------------------------------
%% filtros
fcorte=1e3;
[b,a]=butter(50,fcorte*2/Fs);
s=filtfilt(b,a,s);
%#########################################################################
%############### Quarta Parte - Canal Ruidoso ############################

s_ruidoso = awgn(s,snr,'measured');

%#########################################################################
%#########################################################################


% ------------- Quinta Parte - Desembaralha o Sinal de Audio --------------
s_r = ssbmod(s_ruidoso,Fc,Fs);  % Agora Modula o sinal Audio Recebido


% -------------------------------------------------------------------------

% --------  Sexta Parte - Escuta dos sinais para compara??o  -------------- 
sound(m,Fs)          % Sinal Original
pause(15)
sound(s,Fs)          % Sinal Embaralhado
pause(15)
sound(s_r,Fs)        % Sinal Desembaralhado
% .................... Fim da Simula??o ..................................


% ........... Plota alguns Gr?ficos ...................................... 
% Plota o sinal de mensagem m1 no dominio do tempo e da frequencia
figure(1)         
subplot(2,1,1)
plot(t,m,'b'), grid, 
title ('Sinal de Audio'); xlabel('tempo [s]'), ylabel('ampl. [u.a.]')
axis tight

[M,mn,f,df] = FFT_pot2(m.',dt);  % Determina o espectro
figure(2)
subplot(2,1,1), plot(f,10*log10(fftshift(abs(M))),'b'), grid
title ('Espectro de Pot?ncia em Banda Base');
xlabel('Frequ?ncia[Hz]'), ylabel('PSD [dB/Hz]'), axis tight

% Plota o sinal Multiplexado em QAM no dominio do tempo e da frequencia
figure(1)
subplot(2,1,2), plot(t,s,'g'), grid, title ('Sinal Embaralhado')
xlabel('tempo [s]'), ylabel('ampl. [u.a.]')
axis tight

figure(2)
[S_mod,s1,f_mod,df_mod] = FFT_pot2(s.',dt);           % Espectro
subplot(2,1,2), plot(f_mod,10*log10(fftshift(abs(S_mod))),'g'), grid
title ('Espectro de Pot?ncia em Banda Passante do Sinal Embaralhado');
xlabel('Frequ?ncia[Hz]'), ylabel('PSD [dB/Hz]'), axis tight


% Plota o resultado da modula??o com ru?do no tempo e na frequencia 
figure(3) 
subplot(2,1,1), plot(t,s,'g'), hold on
plot(t,s_ruidoso,'r--'), grid
legend ('Sinal na Entrada do Canal', 'Sinal na Sa?da do Canal')
xlabel('tempo [s]'), ylabel('ampl. [u.a.]'), axis tight

[S_ruido,s_ruido,f_ruido,df_ruido] = FFT_pot2(s_ruidoso.',dt);   % Espectro
subplot(2,1,2), plot(f_mod,10*log10(fftshift(abs(S_mod))),'g'), grid
hold on, plot(f_ruido,10*log10(fftshift(abs(S_ruido))),'r--')
title ('Espectro de Pot?ncia dos Sinais na Entrada e Sa?da do Canal');
xlabel('Frequ?ncia[Hz]'), ylabel('PSD [dB/Hz]')
legend ('Sinal na Entrada do Canal', 'Sinal na Sa?da do Canal')
axis tight

% Plota os sinais desembaralhado e o sinal gerado 
figure(4) 
plot(t,m), hold on
plot(t,s_r,'k--'), grid
xlabel('tempo [s]'), ylabel('ampl. [u.a.]'), axis tight
legend('sinal de Audio gerado', 'sinal de Audio recebido')

figure(5)
[SR] = FFT_pot2(s_r.',dt);   % Espectro
plot(f,10*log10(fftshift(abs(M)))), hold on
plot(f,10*log10(fftshift(abs(SR))),'k--'), grid
title ('Espectro de Pot?ncia em Banda Base');
xlabel('Frequ?ncia[Hz]'), ylabel('PSD [dB/Hz]'), axis tight 
legend('sinal de Audio gerado', 'sinal de Audio recebido')

% =========================================================================
%