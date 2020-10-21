%% Exercicios extra 2
% Digitalizar o audio 
clear all; close all; clc

%% =========================== Parametros =================================
ti=0;
n=8; %numero de bits por amostras

%% ====================== discretizacao do audio ==========================

%leitura do audio
[x,Fs]=audioread('audio.wav'); %audio estereo capturado
x=(x(:,1)); %capturando somente o mono

% Gerando o vetor tempo
dt= 1/Fs;                          % Periodo de amostragem                              
t= (ti:dt:(length(x)-1)*dt).';     % Gera o vetor tempo

N= 2^(n-1); %numero de pontos por amostra

quant= max(x)/(N-1); % Valor da quatizacao do sinal de voz

x_disc = ceil(x(:)/quant) ; % Sinal de audio discretizado

%% ============================== Plots ===================================
%plot(t,x_disc);
plot(t, x_disc, t,x);

