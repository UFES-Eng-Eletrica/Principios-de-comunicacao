%                                                                         %
% =========================================================================
%                                                                         %
%                    - Principios Comunicações I -                        %
%    ----------  Leitura de um arquivo de áudio   -------------           %
%                                                                         %
%                                                                         %
% =========================================================================

% Inicialização
clc, clear all, close all

% ===============  Parâmetros de Simulação ==============================
% Carregar arquivo aúdio do MATLAB
load handel.mat;    % Carregar o arquivo de áudio
%sound(y,Fs)

% ===============  Processamentos ==============================
y = y.';            % Tranforma o vetor em vetor linha
tam = length(y);    % Determina o tamanho do vetor de audio
ts = 1/Fs;          % Determina o periodo de amostragem

% Geração do vetor tempo
t = 0:ts:(tam-1)*ts;

% Aplicação da transformada de Fourier
[Y,y_tf,f,df] = Analisador_de_Espectro(y,ts);


% ===============  Plotagem dos sinais ============================
figure(1)
plot(t,y)
ylabel('Amplitude do sinal de audio (u.a.)')
xlabel('Tempo (s)')
title('Leitura e plotagem de um sinal de audio')

figure(2)
plot(f, 10*log10(fftshift(abs(Y))))
xlabel('Frequencia(Hz)')
ylabel('Densidade espectral de potencia(dB/Hz)')
