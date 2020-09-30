% =========================================================================
%                                                                         %
% Lab 3.II - Principios Comunica??es I -                                  %
%    ----------  Modula??o SSB/SC por Desvio de Fase   --------------     %
%          ......... Com um sinal de Audio   ............                 %
%                                                                         %
% by Prof. Jair Silva                                                     %
%                                                                         %
% =========================================================================

% Inicializa??o
clc, clear all, close all


% ===============  Par?metros de Simula??o ==============================
snr     = 10;  % Rela??o Sinal-Ru?do

% ===============  Leitura do Sinal de Audio ============================
[m, Fs]   = wavread('audio48kHz.wav');     % Carrega o sinal

Fc        = Fs/4;     % Frequencia Central da Modula??o 

% =======================================================================

% --------- Primeira parte - C?lculos Preliminares ----------------------
dt        = 1/Fs;                          % Periodo de amostragem                              
t         = (0:dt:(length(m)-1)*dt).';     % Gera o vetor tempo
% ------------------------------------------------------------------------

% -- Segunda Parte: Gera??o do Sinal e o Correspondente defasado de 90? --
s_hil = hilbert(m);    % Sinal com transformada de Hilbert
% ------------------------------------------------------------------------

% -------       Terceira Parte: Multiplea??o QAM        ------------------
s = modulate(real(s_hil),Fc,Fs,'qam',imag(s_hil));    % Sinal Modulado
% ------------------------------------------------------------------------


%#########################################################################
%############### Terceira Parte - Canal Ruidoso ##########################
s_ruidoso = awgn(s,snr,'measured');
%#########################################################################
%#########################################################################


% ------------- Quarta Parte - Demultiplexa??o QAM   ----------------------
[m1_r, m2_r] = demod(s_ruidoso,Fc,Fs,'qam');    % Demodula o sinal recebido
% -------------------------------------------------------------------------


wavplay(m,Fs)
wavplay(m1_r,Fs)
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
subplot(2,1,2), plot(t,s,'g'), grid, title ('Sinal Multiplexado em QAM')
xlabel('tempo [s]'), ylabel('ampl. [u.a.]')
axis tight

figure(2)
[S_mod,s1,f_mod,df_mod] = FFT_pot2(s.',dt);           % Espectro
subplot(2,1,2), plot(f_mod,10*log10(fftshift(abs(S_mod))),'g'), grid
title ('Espectro de Pot?ncia em Banda Passante (SSB)');
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

% Plota os sinais demodulados e compara com os sinais gerados 
figure(4) 
plot(t,m), hold on
plot(t,m1_r,'k--'), grid
xlabel('tempo [s]'), ylabel('ampl. [u.a.]'), axis tight
legend('sinal de Audio gerado', 'sinal de Audio recebido')

figure(5)
[M1R] = FFT_pot2(m1_r.',dt);   % Espectro
[M2R] = FFT_pot2(m2_r.',dt);   % Espectro
plot(f,10*log10(fftshift(abs(M)))), hold on
plot(f,10*log10(fftshift(abs(M1R))),'k--'), grid
title ('Espectro de Pot?ncia em Banda Base');
xlabel('Frequ?ncia[Hz]'), ylabel('PSD [dB/Hz]'), axis tight 
legend('sinal de Audio gerado', 'sinal de Audio recebido')

% =========================================================================
%