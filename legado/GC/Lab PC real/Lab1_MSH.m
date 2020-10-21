%LABORATÓRIO 1
%atualizado dia 13/09/2018
%Análise espectral

%% Inicialização do script
clear all;
clc;
close all;
format short;

%% parametrização
ti=0; %tempo inicial
tf=1e-6; %tempo final
tam=1024; %tamanho do vetor
A=1;%amplitude da onda
k = 10; %fator de amostragem

%% Processamento
t=linspace(ti,tf,tam); %geração do vetor tempo
%taxa de amostragem e período de amostragem
ta=t(2)-t(1); %determinação do período de amostragem
fa=1/ta;%Cálculo da taxa de amostragem

%frequência da senóide
fc=fa/k; %fc, fa >= k*fmax
x=A*cos(2*pi*fc*t); % criação da função cossenóide desejada
figure, plot(t,x);%plotagem da função senóide

xlabel('Tempo(A)');
ylabel('Amplitude(u.A)');
grid on;
title('Sinal da cossenóide');

%% geração do vetor frequência
df=1/(tam*ta);
freqpositiva= 0:df:(tam/2)*df; %freqüências positivas
freqnegativa=-((tam/2)-1)*df:df:-df; %freqüências negativas
freq=[freqpositiva freqnegativa]; %
figure, plot(freq);

[Sinal_ff,sinal_tf,f,df]= FFT_pot2(x,ta);
figure, plot(f,fftshift(db(abs(Sinal_ff))));
%[Sinal_ff,sinal_tf,f,df] = FFT_pot2(sinal,ts)

%% SINC DO PULSO RETANGULAR 
xquadrada = zeros(size(t));
xquadrada((end/2)-(end/8):(end/2)+(end/8))=ones(size(xquadrada((end/2)- (end/8):(end/2)+(end/8))));
X=fft(xquadrada); %geracao do fft de X onda quadrada 
figure, plot(freq,abs(X));
xlabel('Freqência(Hz)');
ylabel('Amplitude(Hz)');
grid on;
title('Sinc do pulso retangular');
figure, plot(freq,db(abs(X)));
xlabel('Freqência(Hz)');
ylabel('psd(dB/Hz)');
grid on;
title('Sinc do pulso retangular em escala logarítimica');

X2=fftshift(xquadrada); %geracao do fftshift de X onda quadrada
figure, plot(freq, abs(X2));
xlabel('Tempo(A)');
ylabel('Amplitude(u.A)');
grid on;
title('Pulso retangular');

%%Filtragem do espectro Sinc
wn=2e7/(fa/2);
[b,a]=butter(2,wn,'low');
Y=filtfilt(b,a,xquadrada);
figure, plot(Y);
xlabel('Tempo(A)');
ylabel('Amplitude(u.A)');
grid on;
title('Pulso retangular filtrado');


%% Cálculo da potência da cossenóide
Pmn= sum(abs(x).^2)/1024;
Pdbm= 30+10*log10(Pmn);

%% Cálculo da potência da onda quadrada
Pmn2= sum(abs(xquadrada).^2)/1024;
Pdbm2= 10*log10(Pmn2/1e-3);