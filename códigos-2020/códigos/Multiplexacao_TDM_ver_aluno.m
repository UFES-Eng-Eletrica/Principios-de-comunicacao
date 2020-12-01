%
% ------------- Codigo Matlab para Time Division Multiplexing -------------
%
%  Para PC1 - Semestre lectivo 2020/1
%
% -------------------------------------------------------------------------

% Inicialização 
clc; close all; clear all

% Parametrização
M  = 2;             % Nível de modulação
k  = log2(M);       % bits por símbolo
nsamp  = 4;         % Taxa Oversampling (Qtd de pontos para representar o bit)
snr  = 30;          % SNR em dB

% Geração dos sinais 
t = 0:.5:4*pi;           % vetor temposiganal taken upto 4pi
sinal_1 = 8*sin(t);      % sinal da primeira fonte é uma senóide
tam = length(sinal_1);   % qtd de amostras dos sinais
sinal_2 = 8*triang(tam); % o segundo sinal é uma onda triangular

% .......................... Transmissor ................................

% % Transforma os vetores dos dois sinais em um matriz 
for kk = 1:tam
  sinal_mat(1,kk) = sinal_1(kk);      
  sinal_mat(2,kk) = sinal_2(kk);
end  

% Multiplexação TDM em si
sinal_multiplexado = reshape(sinal_mat,1,2*tam);

% Conversão A/D
fator_DC = max(abs(sinal_multiplexado)); % fator para garantir valores positivos
sinal_multiplexado = sinal_multiplexado + fator_DC; % adiciona o fator
sinal_multiplexado = round(sinal_multiplexado);  % arredondamento para simular erro de quantização
sinal_multiplexado_digital = de2bi(sinal_multiplexado);   % conversão em si
[linhas,colunas] = size(sinal_multiplexado_digital);
sinal_multiplexado_digital = sinal_multiplexado_digital(:); % transforma em vetor

% "Modulação" PAM
xmod = pammod(sinal_multiplexado_digital,M);

% Convolucao com o filtro conformador
xmod_up = rectpulse(xmod,nsamp);


% ++++++++++++++++++++++++++++  Canal +++++++++++++++++++++++++++++++++++
% Adiciona ruído Gaussiano branco ao sinal
y_ruido  = awgn(xmod_up,snr,'measured');
% +++++++++++++++++++++++++++++++++++ +++++++++++++++++++++++++++++++++++


% .......................... Receptor ................................
%
% ???????????????????????????????????
%
%


 
% ...... Plotagem dos sinais  ..........

% Tempo Contínuo
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

% Sinais na entrada e saída do canal
figure, plot(real(xmod_up(1:nsamp*50)))       % no tempo
hold on, plot(real(y_ruido(1:nsamp*50)),'r')
figure, plot(db(fftshift(abs(fft(xmod_up))))) % na frequencia



%
% Eof
 

 