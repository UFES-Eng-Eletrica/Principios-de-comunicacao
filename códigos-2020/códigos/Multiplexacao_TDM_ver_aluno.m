%
% ------------- Codigo Matlab para Time Division Multiplexing -------------
%
%  Para PC1 - Semestre lectivo 2020/1
%
% -------------------------------------------------------------------------

% Inicializa��o 
clc; close all; clear all

% Parametriza��o
M  = 2;             % N�vel de modula��o
k  = log2(M);       % bits por s�mbolo
nsamp  = 4;         % Taxa Oversampling (Qtd de pontos para representar o bit)
snr  = 30;          % SNR em dB

% Gera��o dos sinais 
t = 0:.5:4*pi;           % vetor temposiganal taken upto 4pi
sinal_1 = 8*sin(t);      % sinal da primeira fonte � uma sen�ide
tam = length(sinal_1);   % qtd de amostras dos sinais
sinal_2 = 8*triang(tam); % o segundo sinal � uma onda triangular

% .......................... Transmissor ................................

% % Transforma os vetores dos dois sinais em um matriz 
for kk = 1:tam
  sinal_mat(1,kk) = sinal_1(kk);      
  sinal_mat(2,kk) = sinal_2(kk);
end  

% Multiplexa��o TDM em si
sinal_multiplexado = reshape(sinal_mat,1,2*tam);

% Convers�o A/D
fator_DC = max(abs(sinal_multiplexado)); % fator para garantir valores positivos
sinal_multiplexado = sinal_multiplexado + fator_DC; % adiciona o fator
sinal_multiplexado = round(sinal_multiplexado);  % arredondamento para simular erro de quantiza��o
sinal_multiplexado_digital = de2bi(sinal_multiplexado);   % convers�o em si
[linhas,colunas] = size(sinal_multiplexado_digital);
sinal_multiplexado_digital = sinal_multiplexado_digital(:); % transforma em vetor

% "Modula��o" PAM
xmod = pammod(sinal_multiplexado_digital,M);

% Convolucao com o filtro conformador
xmod_up = rectpulse(xmod,nsamp);


% ++++++++++++++++++++++++++++  Canal +++++++++++++++++++++++++++++++++++
% Adiciona ru�do Gaussiano branco ao sinal
y_ruido  = awgn(xmod_up,snr,'measured');
% +++++++++++++++++++++++++++++++++++ +++++++++++++++++++++++++++++++++++


% .......................... Receptor ................................
%
% ???????????????????????????????????
%
%


 
% ...... Plotagem dos sinais  ..........

% Tempo Cont�nuo
figure
subplot(2,2,1);                          
plot(sinal_1), title('Sinal Senoidal'), ylabel('Amplitude'), xlabel('Tempo');
subplot(2,2,2);
plot(sinal_2), title('Sinal Triangular'), ylabel('Amplitude'), xlabel('Tempo');

% Tempo Discreto
subplot(2,2,3);
stem(sinal_1), title('Sinal Senoidal de Tempo Amostrado'),
ylabel('Amplitude '), xlabel('Tempo --->')
subplot(2,2,4);
stem(sinal_2), title('Onda Triangular de Tempo Amostrado');
ylabel('Amplitude'), xlabel('Tempo');

% Sinal Multiplexado
figure, stem(sinal_multiplexado)
title('Sinal Multiplexado'), ylabel('Amplitude'), xlabel('Tempo');

% Sinais na entrada e sa�da do canal
figure, plot(real(xmod_up(1:nsamp*50)))       % no tempo
hold on, plot(real(y_ruido(1:nsamp*50)),'r')
figure, plot(db(fftshift(abs(fft(xmod_up))))) % na frequencia



%
% Eof
 

 