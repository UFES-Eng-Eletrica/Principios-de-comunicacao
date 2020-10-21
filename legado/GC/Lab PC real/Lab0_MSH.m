%LABORATÓRIO 0
%06/09/2018
%Geração de um vetor tempo de 100 posições, com 0.4us de duração

%% Inicialização do script
clear all;
clc;
close all;
format short;

%% Parametrização
ti=0; %instante inicial
tf= 0.4e-6; %instante final
tam=100; %tamanho do vetor
A=1; %amplitude da onda
k=10; %fator de amostragem

%% Processamento
t=linspace(ti,tf,tam); %geraão do vetor tempo
ta=t(2)-t(1); %determinação do período de amostragem
fa=1/ta;%Cálculo da taxa de amostragem
fc=fa/k %frequência da cossenóide
x= A*cos(2*pi*fc*t); %sinal da  cossenóide

%plot(t,x, 'g');
%length(t)= comprimento do vetor
%t(n)= enésimo termo do vetor
%size(t)= números de linhas e colunas do vetor


%% Geração do vetor frequência
df=1/(ta*tam);    
fpos=0:df:(tam/2-1)*df; %espectro de frequência
fneg= -(tam/2)*df:df:-df;
f=[fneg fpos];
plot(f, 'g');
%% Determinando o conteúdo espectral do sinal
X=fft(x); %fast fourier transform x
figure % criar nova figura
%plot(f, db(abs(X)));
plot(f, fftshift(db(abs(X))));

%stem(f, db(abs(X)));



