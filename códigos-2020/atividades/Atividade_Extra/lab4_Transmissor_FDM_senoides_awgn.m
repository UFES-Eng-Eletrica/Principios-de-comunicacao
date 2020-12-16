%                                                                         %
% =========================================================================
%                                                                         %
% Lab 4 - Principios Comunica��es I - Aplica��es Modula��o AM-SSB/SC      %
%             ----  Multiplexa��o FDM  ----                               %
%                                                                         %
% by Prof. Jair Silva                                                     %
%                                                                         %
% =========================================================================

% Inicializa��o
clc, clear all, close all


% ===============  Dados de Simula��o  ===================================
Fs      = 1e6;      % Taxa de amostragem dos  sinais em banda passante 

fm1     = 1000;     % Frequencia central do 1� sinal modulante (Banda Base)
fm2     = 2000;     % Frequencia central do 2� sinal modulante (Banda Base)
fm3     = 3000;     % Frequencia central do 3� sinal modulant (Banda Base)

Fc1     = 0.2e6;    % Frequencia de opera��o da primeira portadora 
Fc2     = 0.3e6;    % Frequencia de opera��o da segunda portadora
Fc3     = 0.4e6;    % Frequencia de opera��o da terceira portadora

snr     = 45;      % Rela��o Sinal-Ru�do [dB]

fcorte1 = 0.55;     % Primeira Freq. corte do filtro de DEMULTIPLEXA��O  
fcorte2 = 0.65;     % Segunda  Freq. corte do filtro de DEMULTIPLEXA��O 
ordem   = 40;       % Ordem do filtro passa faixa de recep��o
% =========================================================================

% C�lculos Preliminares
ta  = 1/Fs;            % Periodo de amostragem dos sinais em banda base
tam = 2048;            % Tamanho dos vetores 
t  = (0:ta:tam*ta).';  % Cria o novo vetor tempo j� em banda passante

% --------- Primeira parte - Gera os sinais a serem multiplexados --------
% Primeiro sinal em Banda Base (Fonte I)
m1  = sin(2*pi*fm1*t);  % primeiro sinal a ser multiplexado 

% Segundo sinal em Banda Base (Fonte II)
m2  = sin(2*pi*fm2*t);  % segundo sinal a ser multiplexado 

% Terceiro sinal em Banda Base (Fonte III)
m3  = sin(2*pi*fm3*t);  % segundo sinal a ser multiplexado 
% ------------------------------------------------------------------------


% ---------- Segunda Parte: Modula��o dos sinais de mensagem -------------
m1_mod = ssbmod(m1,Fc1,Fs);   % Modula a primeira portadora 
m2_mod = ssbmod(m2,Fc2,Fs);   % Modula a segunda portadora 
m3_mod = ssbmod(m3,Fc3,Fs);   % Modula a terceira portadora
% ------------------------------------------------------------------------


%  ---------------- Terceira Parte - Multiplexa��o -----------------------
sinal_mux = m1_mod + m2_mod + m3_mod;  % sinal multiplexado
% ------------------------------------------------------------------------


%#########################################################################
%############### Quarta Parte - Canal Ruidoso ############################

sinal_mux_ruidoso = awgn(sinal_mux,snr,'measured');

%#########################################################################
%#########################################################################


% --------  Receptor ----- 
%
% ????????????????????
%


% .................... Fim da Simula��o ..................................


% ........... Plota alguns Gr�ficos ...................................... 
% Plota o sinal de mensagem m1 no dominio do tempo e da frequencia
figure(1)         
subplot(3,1,1)
plot(t,m1,'b'), grid, 
title ('Fonte I'); xlabel('tempo [s]'), ylabel('ampl. [u.a.]')

[M1,m1n,f1,df1] = FFT_pot2(m1.',ta);  % Determina o espectro
figure(2), plot(f1,10*log10(fftshift(abs(M1))),'b'), grid
title ('Espectro de Pot�ncia em Banda Base');
xlabel('Frequ�ncia[Hz]'), ylabel('PSD [dB/Hz]')

% Plota o sinal de mensagem m2 no dominio do tempo e da frequencia
figure(1)         
subplot(3,1,2)
plot(t,m2,'g'), grid
title ('Fonte II'); xlabel('tempo [s]'), ylabel('ampl. [u.a.]')

[M2,m2n,f2,df2] = FFT_pot2(m2.',ta);   % determina o espectro
figure(2), hold on, plot(f2,10*log10(fftshift(abs(M2))),'g'), grid

% Plota o sinal de mensagem m2 no dominio do tempo e da frequencia
figure(1)         
subplot(3,1,3)
plot(t,m3,'r'), grid
title ('Fonte III'); xlabel('tempo [s]'), ylabel('ampl. [u.a.]')

[M3,m3n,f3,df3] = FFT_pot2(m3.',ta);   % determina o espectro
figure(2), hold on, plot(f3,10*log10(fftshift(abs(M3))),'r'), grid


% Plota os sinais modulados no dominio do tempo e da frequencia
figure(3)
subplot(3,1,1), plot(t,m1_mod,'b'), grid, title ('Portadora I Modulada')
subplot(3,1,2), plot(t,m2_mod,'g'), grid, title ('Portadora II Modulada');
subplot(3,1,3), plot(t,m3_mod,'r'), grid, title ('Portadora III Modulada');
xlabel('tempo [s]')

figure(4)
[M1_mod,m1n_mod,f1_mod,df1_mod] = FFT_pot2(m1_mod.',ta);   % Espectro
[M2_mod,m2n_mod,f2_mod,df2_mod] = FFT_pot2(m2_mod.',ta);   % Espectro
[M3_mod,m3n_mod,f3_mod,df3_mod] = FFT_pot2(m3_mod.',ta);   % Espectro
plot(f1_mod,10*log10(fftshift(abs(M1_mod))),'b'), grid, hold on
plot(f2_mod,10*log10(fftshift(abs(M2_mod))),'g'), grid, hold on
plot(f3_mod,10*log10(fftshift(abs(M3_mod))),'r'), grid
title ('Espectro de Pot�ncia em Banda Passante (SSB)');
xlabel('Frequ�ncia[Hz]'), ylabel('PSD [dB/Hz]')
legend('Portadora I Modulada', 'Portadora II Modulada', 'Portadora III Modulada')


% Plota o resultado da multiplexa��o no tempo e na frequencia 
figure(5) 
subplot(4,1,1), plot(t,sinal_mux,'b'), grid, title ('sinal MULTIPLEXADO')
xlabel('tempo [s]'), ylabel('ampl. [u.a.]')

[SMUX,smux,f1_mux,df1_mux] = FFT_pot2(sinal_mux.',ta);   % Espectro
subplot(4,1,2), plot(f1_mux,10*log10(fftshift(abs(SMUX))),'b')
title ('Espectro de Pot�ncia do sinal MULTIPLEXADO');
xlabel('Frequ�ncia[Hz]'), ylabel('PSD [dB/Hz]')

% Plota o resultado da multiplexa��o com ru�do no tempo e na frequencia 
figure(5) 
subplot(4,1,3), plot(t,sinal_mux_ruidoso,'r'), grid, title ('sinal MULTIPLEXADO com ru�do')
xlabel('tempo [s]'), ylabel('ampl. [u.a.]')

[SMUX_ruido,smux_ruido,f1_mux,df1_mux] = FFT_pot2(sinal_mux_ruidoso.',ta);   % Espectro
subplot(4,1,4), plot(f1_mux,10*log10(fftshift(abs(SMUX_ruido))),'r')
title ('Espectro de Pot�ncia do sinal MULTIPLEXADO com Ru�do');
xlabel('Frequ�ncia[Hz]'), ylabel('PSD [dB/Hz]')


% =========================================================================
%