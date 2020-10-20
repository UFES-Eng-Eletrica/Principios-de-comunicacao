%-----------------------------------------------------------------------%
% Disciplina: Principios de Comunica��o
% Professor: Jair Silva
% Aula: Comandos b�sicos do Matlab
% Data: 24 de Setembro de 2020
% Feito por Ricardo Vieira

%Limpando o prompt
clc, clear all, close all

%% Dados de entrada para vetor tempo
ti = 0.0; %Tempo inicial
tf = 0.1e-06; % Tempo final
tam = 1000; % Quantidade de amostras, tamanho do vetor

%% Processamento\Calculo

%Gerando vetor tempo
t = linspace(ti,tf,tam);

ta  = t(2) - t(1); % Tempo de amostragem

fa = 1/ta; %Frequencia da Amostragem

%% Gerando Cossenoide
A = 1; %Amplitude da cossenoide
theta = 0; %Defasagem Angular da cossenoide

fc = fa/20;% Frequencia da Cossenoide respeitando Nyquist fc < Fs/2

x = A*cos(2*pi*fc*t + theta);

[sinal_ff,sinal_tf,f,df] = FFT_pot2(x,ta); 

%% Potencia de Sinal em Magnitude
% stem(f, sinal_ff);
%plot(f, abs(sinal_ff))
%title('Magnitude da Tranformada de Fourirer do sinal')

%% Potencia em dB
%figure, plot(f,10*log10(fftshift(abs(sinal_ff)))), grid
%title ('Espectro de Pot�ncia');
%xlabel('Frequ�ncia[Hz]'), ylabel('PSD [dB/Hz]')

%% Espectro do Sinal em dBm
figure, plot(f,30 + 10*log10(fftshift(abs(sinal_ff)))), grid
title ('Espectro de Pot�ncia Cossenoide');
xlabel('Frequ�ncia[Hz]'), ylabel('PSD [dBm/Hz]')

%% Potencia do sinal em dBm
P = sqrt(mean(x.^2)); %Potencia do Sinal
Pdbm = 10*log10(P/1e-3) %P em dBm = 30+10*log10(P);

%Sinal de onda quadrada mandado pelo prof
x1 = zeros(size(t));
x1((end/2)-(end/8):(end/2)+(end/8))=ones(size(x1((end/2)- (end/8):(end/2)+(end/8))));

[sinal_ff,sinal_tf,f,df] = FFT_pot2(x1,ta); 

%% Espectro do Sinal em dBm
figure, plot(f,30 + 10*log10(abs(fft(sinal_tf)))), grid
title ('Espectro de Pot�ncia Onda Quadrada');
xlabel('Frequ�ncia[Hz]'), ylabel('PSD [dBm/Hz]')

%% Potencia do sinal em dBm
P = sqrt(mean(x1.^2)); %Potencia do Sinal
Pdbm = 10*log10(P/1e-3) %P em dBm = 30+10*log10(P);
