%% ATIVIDADE EXTRA-CLASSE DA AULA 4
% Áudio de voz e PCM
% Principios de Comunicações I - Prof. Jair
% Aluno: Fabricio Henrique


clear; close all; clc;

% ===============  Gravar Sinal de Audio ================================
%Como o sinal já foi gravado, mantive comentado
disp('Gravação iniciada.');    
 y = audiorecorder; 
 recordblocking(y,10);
disp('Gravação encerrada.');
 data = getaudiodata(y);
 audiowrite('Voz.wav',data,8000);
    
% =======================================================================


% ===============  Leitura do Sinal de Audio ============================
[m, Fs]   = audioread('Voz.wav');     % Carrega o sinal

% =======================================================================

%TOCA O AUDIO
%sound(m);

% --------- Primeira parte - Calculos Preliminares ----------------------
dt        = 1/Fs;                          % Periodo de amostragem                              
t         = (0:dt:(length(m)-1)*dt).';     % Gera o vetor tempo
% ------------------------------------------------------------------------

% Plotar o audio original
figure(1)
plot(t,m);
title('Audio Original');


n = 8; %NUMERO DE BITS POR AMOSTRA

% Quantização (256 níveis)
a=max(max(m))-min(min(m)); %Diferença entre o maximo e minimo valor de mnovo
delta= a/((2^n)-1); %Valor da quantizacao dos degraus entre os niveis
z=(m-min(min(m)))/delta;
mnovoquant=round(z);

%Plota o audio quantizado
figure(2)
plot(t,mnovoquant);
title('Audio Quantizado');
ylim([0 256]);

%Codificacao Binaria
bit=de2bi(mnovoquant,'left-msb');
bit=bit';
bit=bit(:);
bit=bit';