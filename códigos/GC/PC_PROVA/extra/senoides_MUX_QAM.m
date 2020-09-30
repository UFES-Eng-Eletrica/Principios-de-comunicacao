% =========================================================================
%                                                                         %
% Lab 4 - Principios Comunica??es I - Aplica??es Modula??o AM             %
%    ----------  Multiplexa??o QAM  --------------                        %
%                                                                         %
% by Prof. Jair Silva                                                     %
%                                                                         %
% =========================================================================

% Inicializa??o
clc, clear all, close all


% ===============  Dados ou Par?metros de Simula??o  =====================
Fs      = 1e6;      % Taxa de amostragem dos  sinais em banda passante 
Fc      = Fs/4;     % Frequencia Central da Modula??o 
snr     = 20;       % Rela??o Sinal-Ru?do
% ========================================================================

% C?lculos Preliminares
ta  = 1/Fs;             % Periodo de amostragem dos sinais em banda base
tam = 2048;             % Tamanho dos vetores 
t   = (0:ta:tam*ta).';  % Cria o novo vetor tempo j? em banda passante

% --------- Primeira parte - Gera os sinais a serem multiplexados --------
% Primeiro sinal em Banda Base (Fonte I)
fc1 = 1000;             % Frequencia central do primeiro sinal (Banda Base)
m1  = sin(2*pi*fc1*t);  % primeiro sinal a ser multiplexado 

% Segundo sinal em Banda Base (Fonte II)
fc2 = 2000;             % Frequencia central do segundo sinal (Banda Base)
m2  = sin(2*pi*fc2*t);  % segundo sinal a ser multiplexado 
% ------------------------------------------------------------------------


% -------       Segunda Parte: Multiplexa??o QAM         ------------------
s = modulate(m1,Fc,Fs,'qam',m2);    % Sinal Modulado/Multiplexado
% ------------------------------------------------------------------------


%#########################################################################
%############### Terceira Parte - Canal Ruidoso ##########################
s_ruidoso = awgn(s,snr,'measured');
%#########################################################################
%#########################################################################


% ------------- Quarta Parte - Demultiplexa??o QAM   ----------------------
[m1_r, m2_r] = demod(s_ruidoso,Fc,Fs,'qam');    % Demodula o sinal recebido
% -------------------------------------------------------------------------

% .................... Fim da Simula??o ..................................


% ........... Plota alguns Gr?ficos ...................................... 
% Plota o sinal de mensagem m1 no dominio do tempo e da frequencia
figure(1)         
subplot(3,1,1)
plot(t,m1,'r'), grid, 
title ('Fonte I'); xlabel('tempo [s]'), ylabel('ampl. [u.a.]')
axis tight

[M1,m1n,f1,df1] = FFT_pot2(m1.',ta);  % Determina o espectro
figure(2)
subplot(3,1,1), plot(f1,10*log10(fftshift(abs(M1))),'r'), grid
title ('Espectro de Pot?ncia em Banda Base da Fonte I');
xlabel('Frequ?ncia[Hz]'), ylabel('PSD [dB/Hz]')
axis tight

% Plota o sinal de mensagem m2 no dominio do tempo e da frequencia
figure(1)         
subplot(3,1,2)
plot(t,m2), grid
title ('Fonte II'); xlabel('tempo [s]'), ylabel('ampl. [u.a.]')
axis tight

[M2,m2n,f2,df2] = FFT_pot2(m2.',ta);   % determina o espectro
figure(2), hold on
subplot(3,1,2),plot(f2,10*log10(fftshift(abs(M2)))), grid
title ('Espectro de Pot?ncia em Banda Base da Fonte II');
xlabel('Frequ?ncia[Hz]'), ylabel('PSD [dB/Hz]')
axis tight


% Plota o sinal modulado em QAM no dominio do tempo e da frequencia
figure(1)
subplot(3,1,3), plot(t,s,'g'), grid
title ('Sinal Modulado/Multiplexado em QAM')
xlabel('tempo [s]'), ylabel('ampl. [u.a.]'), axis tight


[S_mod,s1,f_mod,df_mod] = FFT_pot2(s.',ta);           % Espectro
figure(2), hold on
subplot(3,1,3),plot(f_mod,10*log10(fftshift(abs(S_mod))),'g'), grid
title ('Espectro de Pot?ncia em Banda Passante (DSB)');
xlabel('Frequ?ncia[Hz]'), ylabel('PSD [dB/Hz]'), axis tight


% Plota o resultado da modula??o com ru?do no tempo e na frequencia 
figure(3) 
subplot(2,1,1), plot(t,s,'g'), hold on
plot(t,s_ruidoso,'r--'), grid
legend ('Sinal na entrada do canal)', 'Sinal na Sa?da do Canal')
xlabel('tempo [s]'), ylabel('ampl. [u.a.]'), axis tight

[S_ruido,s_ruido,f_ruido,df_ruido] = FFT_pot2(s_ruidoso.',ta);   % Espectro
subplot(2,1,2), plot(f_mod,10*log10(fftshift(abs(S_mod))),'g'),
hold on, plot(f_ruido,10*log10(fftshift(abs(S_ruido))),'r--')
title ('Espectro de Pot?ncia dos sinais na entrada e sa?da do Canal');
xlabel('Frequ?ncia[Hz]'), ylabel('PSD [dB/Hz]'), axis tight

% Plota os sinais demodulados e compara com os sinais gerados 
figure(4) 
subplot(2,1,1), plot(t,m1), hold on
plot(t,m1_r,'k--'), grid
xlabel('tempo [s]'), ylabel('ampl. [u.a.]')
legend('sinal gerado na Fonte I', 'sinal recebido no Destino I')
axis tight

subplot(2,1,2), plot(t,m2_r,'k.'), hold on
plot(t,m2), grid
xlabel('tempo [s]'), ylabel('ampl. [u.a.]')
legend('sinal gerado na Fonte II', 'sinal recebido no Destino II')
axis tight


figure(5)
[M1R] = FFT_pot2(m1_r.',ta);   % Espectro
[M2R] = FFT_pot2(m2_r.',ta);   % Espectro
subplot(2,1,1), plot(f1,10*log10(fftshift(abs(M1)))), hold on
plot(f1,10*log10(fftshift(abs(M1R))),'k--'), grid
title ('Espectro de Pot?ncia em Banda Base');
xlabel('Frequ?ncia[Hz]'), ylabel('PSD [dB/Hz]') 
legend('sinal gerado na Fonte I', 'sinal recebido no Destino I')

subplot(2,1,2), plot(f1,10*log10(fftshift(abs(M2)))), hold on
plot(f1,10*log10(fftshift(abs(M2R))),'k.'), grid
title ('Espectro de Pot?ncia em Banda Base');
xlabel('Frequ?ncia[Hz]'), ylabel('PSD [dB/Hz]') 
legend('sinal gerado na Fonte II', 'sinal recebido no Destino II')

% =========================================================================
%