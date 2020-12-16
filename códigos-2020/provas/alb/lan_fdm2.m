% %
% =========================================================================
% %
% Lab 4 - Principios Comunicacoes I - Aplicacoes Modulacao AM %
% ---- Multiplexacao FDM ---- %
% %
% by Prof. Jair Silva %
% %
% =========================================================================
% Inicializacao
clc, clear all, close all

% =============== Dados de Simulacao ===================================

Fs = 1e6; % Taxa de amostragem dos sinais em banda passante
Fc1 = 0.4e6; % Frequencia de operacao do primeiro sinal
Fc2 = 0.3e6; % Frequencia de operacao do segundo sinal
Fc3 = 0.05e6; % Frequencia de operacao do terceiro sinal
Fc4 = 0.25e6; %Frequencia de operacao do quarto sinal

tam = 5000; %Tamanho das mensagens
snr = 100; % Relacao Sinal-Ruido

fcorte1 = 0.02; % Primeira Freq. corte do filtro de DEMULTIPLEXACAO
fcorte2 = 0.65; % Segunda Freq. corte do filtro de DEMULTIPLEXACAO

ordem = 40; % Ordem do filtro passa faixa de recepcao

% =========================================================================
% --------- Primeira parte - Gera os sinais a serem multiplexados --------

% Vamos comecar pelo segundo sinal a ser multiplexado

[m2, Fs2] = audioread('audio.ogg'); % Carrega o sinal
dt2 = 1/Fs2; % Periodo de amostragem
t2 = (0:dt2:(length(m2)-1)*dt2).'; % Gera o vetor tempo

% Plota o sinal de mensagem m2 no dominio do tempo e da frequencia
figure(1)
subplot(3,1,2)
plot(t2,m2), grid
title ('Sinal de audio no dominio do tempo');
xlabel('tempo [s]'), ylabel('ampl. [u.a.]')
[M2,m2n,f2,df2] = FFT_pot2(m2.',dt2); % determina o espectro
figure(2), plot(f2,10*log10(fftshift(abs(M2)))), grid
title ('Espectro de Potencia em Banda Base');
xlabel('Frequencia[Hz]'), ylabel('PSD [dB/Hz]')

% ------- Agora sim gera o primeiro sinal a ser multiplexado -------------

fc1 = 1000; % Frequencia central do primeiro sinal (Banda Base)
m1 = sin(2*pi*fc1*t2); % primeiro sinal a ser multiplexado

% Plota o sinal de mensagem m1 no dominio do tempo e da frequencia
figure(1)
subplot(3,1,1)
plot(t2,m1,'r'), grid,
title ('Sinal Tonal'); xlabel('tempo [s]'), ylabel('ampl. [u.a.]')
[M1,m1n,f1,df1] = FFT_pot2(m1.',dt2); % Determina o espectro
figure(2), hold on, plot(f1,10*log10(fftshift(abs(M1))),'r'), grid

% ------- O quarto sinal a ser multiplexado -------------
nsamp_m4 = 10;
size_img = [70 70]; %Dimensoes da imagem
tam_img = size_img(1)*size_img(2);

m4 = rgb2gray(imresize(imread('turtle.png'), size_img)); %Converter imagem em escala de cinza 
figure;imshow(m4); title("Imagem enviada");

m4 = reshape(m4, 1, []);         %Vetorizando a imagem
m4 = [m4 zeros(1,tam-tam_img)];  %Completando a mensagem com zeros
m4 = rectpulse(double(m4), nsamp_m4);   %Ampliando os pulsos
m4 = m4.';

figure; stairs(m4(1:50)); title("Amostra do Sinal modulante de Imagem");

[M4,~,f,~] = FFT_pot2(m4.', 1/Fs); % Determina o espectro
figure(2), hold on, plot(f,10*log10(fftshift(abs(M4))),'k'), grid
legend('sinal de audio', 'senoide', 'onda triangular')
% ----- Gera o terceiro sinal a ser multiplexado - Onda triangular --------

Fs3 = Fs2; % Multiplo da amostragem do segundo sinal
dt3 = 1/Fs3; % Periodo de amostragem
t3 = 0:dt3:0.04; % Gera o vetor tempo do terceiro sinal
m3 = sawtooth((t2+4)/4)+sawtooth((t2-4)/4); % Gera o terceiro sinal

% Plota o sinal de mensagem m3 no dominio do tempo e da frequencia
figure(1)
subplot(3,1,3)
plot(t2,m3,'k'), grid
title ('Onda triangular');
xlabel('tempo [s]'), ylabel('ampl. [u.a.]')
[M3,m3n,f3,df3] = FFT_pot2(m3.',dt3); % Determina o espectro
figure(2), hold on, plot(f3,10*log10(fftshift(abs(M3))),'k'), grid
legend('sinal de audio', 'senoide', 'onda triangular')

% ---------- Segunda Parte: Modulacao dos sinais de mensagem -------------

m1_mod = ssbmod(m1,Fc1,Fs); % Modula o primeiro sinal
m2_mod = ssbmod(m2,Fc2,Fs); % Modula o segundo sinal
m3_mod = ssbmod(m3,Fc3,Fs); % Modula o terceiro sinal
m4_mod = ssbmod(m4,Fc4,Fs); %Modula o quarto sinal

dt_mod = 1/Fs; % Periodo de amostragem dos sinais modulados

% Cria o novo vetor tempo - o dos sinais ja modulados
t_mod = (0:dt_mod:(length(m1_mod)-1)*dt_mod).';

% Plota os sinais modulados no dominio do tempo e da frequencia
figure(3)
subplot(4,1,1), plot(t_mod,m1_mod,'r'), grid, title ('sinal senoidal modulada')
subplot(4,1,2), plot(t_mod,m2_mod,'b'), grid, title ('sinal de audio modulado');
subplot(4,2,1), plot(t_mod,m3_mod,'k'), grid, title ('Onda triangular modulada');
subplot(4,2,2), plot(t_mod,m4_mod,'r'), grid, title ('Sinal de imagem modulado');
xlabel('tempo [s]')
figure(4)
[M1_mod,m1n_mod,f1_mod,df1_mod] = FFT_pot2(m1_mod.',dt_mod); % Espectro
[M2_mod,m2n_mod,f2_mod,df2_mod] = FFT_pot2(m2_mod.',dt_mod); % Espectro
[M3_mod,m3n_mod,f3_mod,df3_mod] = FFT_pot2(m3_mod.',dt_mod); % Espectro
[M4_mod,m4n_mod,f4_mod,df4_mod] = FFT_pot2(m4_mod.',dt_mod); % Espectro
plot(f1_mod,10*log10(fftshift(abs(M1_mod))),'r'), grid, hold on
plot(f2_mod,10*log10(fftshift(abs(M2_mod))),'b'), grid, hold on
plot(f3_mod,10*log10(fftshift(abs(M3_mod))),'k'), grid
plot(f4_mod,10*log10(fftshift(abs(M4_mod))),'r'), grid
title ('Espectro de Potencia em Banda Passante (SSB)');
xlabel('Frequencia[Hz]'), ylabel('PSD [dB/Hz]')
legend('senoide', 'sinal de audio', 'onda triangular', 'sinal de imagem')

% ---------------- Terceira Parte - Multiplexacao -----------------------

sinal_mux = m1_mod + m2_mod + m3_mod + m4_mod; % sinal multiplexado

% Plota o resultado da multiplexacao no tempo e na frequencia
figure(5)
subplot(2,1,1), plot(t_mod,sinal_mux,'g'), grid, title ('sinal MULTIPLEXADO')
xlabel('tempo [s]'), ylabel('ampl. [u.a.]')
[SMUX,smux,f1_mux,df1_mux] = FFT_pot2(sinal_mux.',dt_mod); % Espectro
subplot(2,1,2), plot(f1_mux,10*log10(fftshift(abs(SMUX))),'g')
title ('Espectro de Potencia do sinal MULTIPLEXADO');
xlabel('Frequencia[Hz]'), ylabel('PSD [dB/Hz]')

% ############### Quarta Parte - Canal Ruidoso ###########################
sinal_mux_ruidoso = awgn(sinal_mux,snr,'measured');

% #########################################################################
% ****** Quinta Parte - Demultiplexacao usando Filtro Passa Faixa *******

h = fir1(ordem,[0.25 0.4]); % Cria o filtro passa banda
figure(6), freqz(h,1,512) % Plota a resposta do filtro
sinal_demux = filter(h,1,sinal_mux_ruidoso); % Filtra/demultiplexa

% Plota o resultado da demultiplexacao no tempo e na frequencia
figure(7)
subplot(2,1,1), plot(t_mod,sinal_demux,'r'), grid, title ('sinal DEMULTIPLEXADO')
xlabel('tempo [s]'), ylabel('ampl. [u.a.]')
[SDEMUX,smux,f2_demux,df2_demux] = FFT_pot2(sinal_demux.',dt_mod); % Espectro
subplot(2,1,2), plot(f1_mux,10*log10(fftshift(abs(SDEMUX))),'r')
title ('Espectro de Potencia do sinal DEMULTIPLEXADO');
xlabel('Frequencia[Hz]'), ylabel('PSD [dB/Hz]')

% ************* Sexta Parte - Demodulacao (SSB) **************************
h2 = fir1(ordem,[0.5 0.8]);  %Filtro Passa-Faixa Canal 2
m2_demod = filter(h2,1,sinal_demux);
m2_demod = ssbdemod(m2_demod,Fc2,Fs); % Modula o segundo sinal

% Plota o resultado da demodulacao no tempo e na frequencia
figure(8)
subplot(2,1,1), plot(t2,m2_demod,'b'), grid, title ('sinal DEMODULADO')
xlabel('tempo [s]'), ylabel('ampl. [u.a.]')
[SDEMOD,sdemod,f2_demod,df2_demod] = FFT_pot2(m2_demod.',dt2); % Espectro
subplot(2,1,2), plot(f2_demux,10*log10(fftshift(abs(SDEMOD))),'b')
title ('Espectro de Potencia do sinal DEMODULADO');
xlabel('Frequencia[Hz]'), ylabel('PSD [dB/Hz]')


% ************* Setima Parte - Demodulacao (SSB) **************************

h4 = fir1(128,[0.1 0.5]);  %Filtro Passa-Faixa Canal 2
m4_demod = filter(h4,1,sinal_demux);
m4_demod = ssbdemod(m4_demod,Fc4,Fs); % Modula o segundo sinal
%h4 = fir1(128, 0.0,'low');
%m4_demod = filter(h4, 1, m4_demod);

%m4_demod = round(intdump(m4_demod, nsamp_m4));
%isequal(m4, m4_demod);

% Plota o resultado da demodulacao no tempo e na frequencia
figure(8)
subplot(2,1,1), plot(t2,m4_demod,'b'), grid, title ('sinal DEMODULADO')
xlabel('tempo [s]'), ylabel('ampl. [u.a.]')
[SDEMOD,sdemod,f2_demod,df2_demod] = FFT_pot2(m4_demod.',dt2); % Espectro
subplot(2,1,2), plot(f2_demux,10*log10(fftshift(abs(SDEMOD))),'b')
title ('Espectro de Potencia do sinal DEMODULADO');
xlabel('Frequencia[Hz]'), ylabel('PSD [dB/Hz]')

% =============== Compara os sinais Gerado e Recuperado ===============

% Comparacao escutando os sinais de audio
sound(m2, Fs2); % Joga o sinal gerado na caixa de som
pause(10) % Espera um tempinho
%sound(sinal_mux,Fs2) % Joga o sinal multiplexado na caixa de som
%pause(10) % Espera um tempinho
sound(10*m2_demod, Fs2); % Joga o sinal recuperado na caixa de som

% Comparacao em figuras
figure(9)
subplot(2,1,1), plot(t2,m2_demod,'b'), grid
hold on, plot(t2,m2,'r--')
title ('Comparando os sinais'), xlabel('tempo [s]'), ylabel('ampl. [u.a.]')
subplot(2,1,2), plot(f2_demod,10*log10(fftshift(abs(SDEMOD))),'b-'), grid
hold on, plot(f2,10*log10(fftshift(abs(M2))),'r--')
title ('Comparando os Espectros dos sinais Gerado e Recuperado');
xlabel('Frequencia[Hz]'), ylabel('PSD [dB/Hz]');