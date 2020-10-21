%                                                                         %
% =========================================================================
%                                                                         %
% Lab 4 - Principios Comunica??es I - Aplica??es Modula??o AM             %
%             ----  Multiplexa??o FDM  ----                               %
%                                                                         %
% by Prof. Jair Silva                                                     %
%                                                                         %
% =========================================================================
% Obs: embaralhador de áudio.
% Inicializa??o
clc, clear all, close all


% ===============  Dados de Simula??o  ===================================
Fs      = 1e6;      % Taxa de amostragem dos  sinais em banda passante 
Fc1     = 0.4e6;    % Frequencia de opera??o do primeiro sinal 
Fc2     = 0.3e6;    % Frequencia de opera??o do segundo sinal
Fc3     = 0.05e6;   % Frequencia de opera??o do terceiro sinal
snr     = 100;      % Rela??o Sinal-Ru?do
fcorte1 = 0.2;      % Primeira Freq. corte do filtro de DEMULTIPLEXA??O  
fcorte2 = 0.65;     % Segunda  Freq. corte do filtro de DEMULTIPLEXA??O 
ordem   = 40;       % Ordem do filtro passa faixa de recep??o
% =========================================================================



% --------- Primeira parte - Gera os sinais a serem multiplexados --------
% Vamos come?ar pelo segundo sinal a ser multiplexado 
[m2, Fs2] = wavread('salerno.wav');     % Carrega o sinal
dt2       = 1/Fs2;                         % Periodo de amostragem                              
t2        = (0:dt2:(length(m2)-1)*dt2).';  % Gera o vetor tempo

% Plota o sinal de mensagem m2 no dominio do tempo e da frequencia
figure(1)         
subplot(3,1,2)
plot(t2,m2), grid
title ('Sinal de audio no dominio do tempo');
xlabel('tempo [s]'), ylabel('ampl. [u.a.]')

[M2,m2n,f2,df2] = FFT_pot2(m2.',dt2);   % determina o espectro
figure(2), plot(f2,10*log10(fftshift(abs(M2)))), grid
title ('Espectro de Pot?ncia em Banda Base');
xlabel('Frequ?ncia[Hz]'), ylabel('PSD [dB/Hz]')


% -------  Agora sim gera o primeiro sinal a ser multiplexado -------------
fc1 = 1000;             % Frequencia central do primeiro sinal (Banda Base)
m1  = sin(2*pi*fc1*t2); % primeiro sinal a ser multiplexado 

% Plota o sinal de mensagem m1 no dominio do tempo e da frequencia
figure(1)         
subplot(3,1,1)
plot(t2,m1,'r'), grid, 
title ('Sinal Tonal'); xlabel('tempo [s]'), ylabel('ampl. [u.a.]')

[M1,m1n,f1,df1] = FFT_pot2(m1.',dt2);  % Determina o espectro
figure(2), hold on, plot(f1,10*log10(fftshift(abs(M1))),'r'), grid


% ----- Gera o terceiro sinal a ser multiplexado - Onda triangular --------
Fs3 = Fs2;         % Multiplo da amostragem do segundo sinal
dt3 = 1/Fs3;       % Periodo de amostragem
t3  = 0:dt3:0.04;  % Gera o vetor tempo do terceiro sinal
m3  = triangl((t2+4)/4)+triangl((t2-4)/4); % Gera o terceiro sinal

% Plota o sinal de mensagem m3 no dominio do tempo e da frequencia
figure(1)         
subplot(3,1,3)
plot(t2,m3,'k'), grid
title ('Onda triangular');
xlabel('tempo [s]'), ylabel('ampl. [u.a.]')

[M3,m3n,f3,df3] = FFT_pot2(m3.',dt3);  % Determina o espectro
figure(2), hold on, plot(f3,10*log10(fftshift(abs(M3))),'k'), grid
legend('sinal de audio', 'senoide', 'onda triangular')




% ---------- Segunda Parte: Modula??o dos sinais de mensagem -------------
m1_mod = ssbmod(m1,Fc1,Fs);   % Modula o primeiro sinal
m2_mod = ssbmod(m2,Fc2,Fs);   % Modula o segundo sinal
m3_mod = ssbmod(m3,Fc3,Fs);   % Modula o terceiro sinal
dt_mod = 1/Fs;                % Periodo de amostragem dos sinais modulados

% Cria o novo vetor tempo - o dos sinais j? modulados
t_mod  = (0:dt_mod:(length(m1_mod)-1)*dt_mod).';

% Plota os sinais modulados no dominio do tempo e da frequencia
figure(3)
subplot(3,1,1), plot(t_mod,m1_mod,'r'), grid, title ('sinal senoidal modulada')
subplot(3,1,2), plot(t_mod,m2_mod,'b'), grid, title ('sinal de audio modulado');
subplot(3,1,3), plot(t_mod,m3_mod,'k'), grid, title ('Onda triangular modulada');
xlabel('tempo [s]')

figure(4)
[M1_mod,m1n_mod,f1_mod,df1_mod] = FFT_pot2(m1_mod.',dt_mod);   % Espectro
[M2_mod,m2n_mod,f2_mod,df2_mod] = FFT_pot2(m2_mod.',dt_mod);   % Espectro
[M3_mod,m3n_mod,f3_mod,df3_mod] = FFT_pot2(m3_mod.',dt_mod);   % Espectro
plot(f1_mod,10*log10(fftshift(abs(M1_mod))),'r'), grid, hold on
plot(f2_mod,10*log10(fftshift(abs(M2_mod))),'b'), grid, hold on
plot(f3_mod,10*log10(fftshift(abs(M3_mod))),'k'), grid
title ('Espectro de Pot?ncia em Banda Passante (SSB)');
xlabel('Frequ?ncia[Hz]'), ylabel('PSD [dB/Hz]')
legend('senoide', 'sinal de audio', 'onda triangular')



%  ---------------- Terceira Parte - Multiplexa??o -----------------------

sinal_mux = m1_mod + m2_mod + m3_mod;  % sinal multiplexado

% Plota o resultado da multiplexa??o no tempo e na frequencia 
figure(5) 
subplot(2,1,1), plot(t_mod,sinal_mux,'g'), grid, title ('sinal MULTIPLEXADO')
xlabel('tempo [s]'), ylabel('ampl. [u.a.]')

[SMUX,smux,f1_mux,df1_mux] = FFT_pot2(sinal_mux.',dt_mod);   % Espectro
subplot(2,1,2), plot(f1_mux,10*log10(fftshift(abs(SMUX))),'g')
title ('Espectro de Pot?ncia do sinal MULTIPLEXADO');
xlabel('Frequ?ncia[Hz]'), ylabel('PSD [dB/Hz]')




% ############### Quarta Parte - Canal Ruidoso ###########################

sinal_mux_ruidoso = awgn(sinal_mux,snr,'measured');

% #########################################################################




% ******  Quinta Parte - Demultiplexa??o usando Filtro Passa Faixa ******* 
h = fir1(ordem,[fcorte1 fcorte2]); % Cria o filtro passa banda               
figure(6), freqz(h,1,512)          % Plota a resposta do filtro

sinal_demux = filter(h,1,sinal_mux_ruidoso);  % Filtra/demultiplexa

% Plota o resultado da demultiplexa??o no tempo e na frequencia 
figure(7) 
subplot(2,1,1), plot(t_mod,sinal_demux,'r'), grid, title ('sinal DEMULTIPLEXADO')
xlabel('tempo [s]'), ylabel('ampl. [u.a.]')

[SDEMUX,smux,f2_demux,df2_demux] = FFT_pot2(sinal_demux.',dt_mod);   % Espectro
subplot(2,1,2), plot(f1_mux,10*log10(fftshift(abs(SDEMUX))),'r')
title ('Espectro de Pot?ncia do sinal DEMULTIPLEXADO');
xlabel('Frequ?ncia[Hz]'), ylabel('PSD [dB/Hz]')



% ************* Sexta Parte - Demodula??o (SSB) **************************

m2_demod = ssbdemod(sinal_demux,Fc2,Fs);   % Modula o segundo sinal 

% Plota o resultado da demodula??o no tempo e na frequencia 
figure(8) 
subplot(2,1,1), plot(t2,m2_demod,'b'), grid, title ('sinal DEMODULADO')
xlabel('tempo [s]'), ylabel('ampl. [u.a.]')

[SDEMOD,sdemod,f2_demod,df2_demod] = FFT_pot2(m2_demod.',dt2);   % Espectro
subplot(2,1,2), plot(f2_demux,10*log10(fftshift(abs(SDEMOD))),'b')
title ('Espectro de Pot?ncia do sinal DEMODULADO');
xlabel('Frequ?ncia[Hz]'), ylabel('PSD [dB/Hz]')



% ===============  Compara os sinais Gerado e Recuperado   ===============
% Compara??o escutando os sinais de audio
sound(m2, Fs2);        % Joga o sinal gerado na caixa de som
pause(10)              % Espera um tempinho
%sound(sinal_mux,Fs2)   % Joga o sinal multiplado na caixa de som
%pause(10)              % Espera um tempinho
sound(m2_demod, Fs2);  % Joga o sinal recuperado na caixa de som

% Compara??o em figuras
figure(9)
subplot(2,1,1), plot(t2,m2_demod,'b'), grid 
hold on, plot(t2,m2,'r--')
title ('Comparando os sinais'), xlabel('tempo [s]'), ylabel('ampl. [u.a.]')

subplot(2,1,2), plot(f2_demod,10*log10(fftshift(abs(SDEMOD))),'b-'), grid
hold on, plot(f2,10*log10(fftshift(abs(M2))),'r--')
title ('Comparando os Espectros dos sinais Gerado e Recuperado');
xlabel('Frequ?ncia[Hz]'), ylabel('PSD [dB/Hz]')

% =========================================================================
%