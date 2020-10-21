%                                                                         %
% =========================================================================
%                                                                         %
% Lab 3.II - Principios Comunica??es I -                                  %
%    ----------  Modula??o SSB/SC por Desvio de Fase   --------------     %
%                                                                         %
% by Prof. Jair Silva                                                     %
%                                                                         %
% =========================================================================

% Inicializa??o
clc, clear all, close all


% ===============  Dados de Simula??o  ==================================
Fs      = 1e6;      % Taxa de amostragem dos  sinais em banda passante 
Fc      = Fs/4;     % Frequencia Central da Modula??o 
snr     = 20;      % Rela??o Sinal-Ru?do
fcorte1 = 0.2;      % Primeira Freq. corte do filtro de DEMULTIPLEXA??O  
fcorte2 = 0.5;     % Segunda  Freq. corte do filtro de DEMULTIPLEXA??O 
ordem   = 40;       % Ordem do filtro passa faixa de recep??o
% ========================================================================

% C?lculos Preliminares
ta  = 1/Fs;            % Periodo de amostragem dos sinais em banda base
tam = 2048;            % Tamanho dos vetores 
t  = (0:ta:tam*ta).';  % Cria o novo vetor tempo j? em banda passante

% --------- Primeira parte - Gera os sinais a serem multiplexados --------
% Sinal em Banda Base (Fonte I)
fc1 = 1000;             % Frequencia central do primeiro sinal (Banda Base)
m1  = sin(2*pi*fc1*t);  % primeiro sinal a ser multiplexado 
% ------------------------------------------------------------------------

% -- Segunda Parte: Gera??o do Sinal e o Correspondente defasado de 90? --
s_hil = hilbert(m1);    % Sinal Modulado
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

% .................... Fim da Simula??o ..................................


% ........... Plota alguns Gr?ficos ...................................... 
% Plota o sinal de mensagem m1 no dominio do tempo e da frequencia
figure(1)         
subplot(2,1,1)
plot(t,m1,'b'), grid, 
title ('Fonte I'); xlabel('tempo [s]'), ylabel('ampl. [u.a.]')
axis tight

[M1,m1n,f1,df1] = FFT_pot2(m1.',ta);  % Determina o espectro
figure(2)
subplot(2,1,1), plot(f1,10*log10(fftshift(abs(M1))),'b'), grid
title ('Espectro de Pot?ncia em Banda Base');
xlabel('Frequ?ncia[Hz]'), ylabel('PSD [dB/Hz]'), axis tight

% Plota o sinal modulado em QAM no dominio do tempo e da frequencia
figure(1)
subplot(2,1,2), plot(t,s,'g'), grid, title ('Sinal Modulado em QAM')
xlabel('tempo [s]'), ylabel('ampl. [u.a.]')
axis tight

figure(2)
[S_mod,s1,f_mod,df_mod] = FFT_pot2(s.',ta);           % Espectro
subplot(2,1,2), plot(f_mod,10*log10(fftshift(abs(S_mod))),'g'), grid
title ('Espectro de Pot?ncia em Banda Passante (SSB)');
xlabel('Frequ?ncia[Hz]'), ylabel('PSD [dB/Hz]'), axis tight


% Plota o resultado da modula??o com ru?do no tempo e na frequencia 
figure(3) 
subplot(2,1,1), plot(t,s,'g'), hold on
plot(t,s_ruidoso,'r--'), grid
legend ('Sinal na Entrada do Canal', 'Sinal na Sa?da do Canal')
xlabel('tempo [s]'), ylabel('ampl. [u.a.]'), axis tight

[S_ruido,s_ruido,f_ruido,df_ruido] = FFT_pot2(s_ruidoso.',ta);   % Espectro
subplot(2,1,2), plot(f_mod,10*log10(fftshift(abs(S_mod))),'g'), grid
hold on, plot(f_ruido,10*log10(fftshift(abs(S_ruido))),'r--')
title ('Espectro de Pot?ncia dos Sinais na Entrada e Sa?da do Canal');
xlabel('Frequ?ncia[Hz]'), ylabel('PSD [dB/Hz]')
legend ('Sinal na Entrada do Canal', 'Sinal na Sa?da do Canal')
axis tight

% Plota os sinais demodulados e compara com os sinais gerados 
figure(4) 
plot(t,m1), hold on
plot(t,m1_r,'k--'), grid
xlabel('tempo [s]'), ylabel('ampl. [u.a.]'), axis tight
legend('sinal gerado na Fonte I', 'sinal recebido no Destino I')

figure(5)
[M1R] = FFT_pot2(m1_r.',ta);   % Espectro
[M2R] = FFT_pot2(m2_r.',ta);   % Espectro
plot(f1,10*log10(fftshift(abs(M1)))), hold on
plot(f1,10*log10(fftshift(abs(M1R))),'k--'), grid
title ('Espectro de Pot?ncia em Banda Base');
xlabel('Frequ?ncia[Hz]'), ylabel('PSD [dB/Hz]'), axis tight 
legend('sinal gerado na Fonte I', 'sinal recebido no Destino I')

% =========================================================================
%