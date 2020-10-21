% Principio de Comunicação - Aula 4.
% Wagner Trarbach Frank

clear all; close all; clc;  % limpa Workspace, fecha imagens e limpa Command Window

% ===============  Parametros de Simulação ==============================
Q = 1/sqrt(2);      % Fator de qualidade
G = -40;            % Ganho/atenuação
Fc = 18000;         % Frequência corte
fc = 240000;          % Frequência maxima
Fmax = fc + Fc;        % F maximo
Famostragem = 5*Fmax;
A = 1;

% ===============  Leitura do Sinal de Audio=============================
[x, Fs] = audioread('audio48kHz.wav');     % Carrega o sinal

% =================== Calculos Preliminares =============================
Ts = 1/Fs;                         % Periodo de amostragem
Ts2 = 1/Famostragem;
t = (0:Ts:(length(x)-1)*Ts).';     % Gera o vetor tempo
tnovo = (0:Ts2:(length(x)-1)*Ts2).';     % Gera o vetor tempo novo

% ========================= Filtro ======================================

[a,b] = butter(9, Fc/(Fs/2));

y = filter(a,b,x);          % Filtragem do áudio

p = A*cos(2*pi*fc*tnovo);
sinal = p.*y;
% Calcula os espectros dos sinais - pulso quadrado e pulso quadrado modulado 
[X,sinal_tf,f,df] = FFT_pot2(x.',Ts);  % Determina o espectro
[Y,sinal_tf,f,df] = FFT_pot2(y',Ts);   % Determina o espectro
[P,sinal_tf,f,df] = FFT_pot2(sinal.',Ts2);  % Determina o espectro


% ====================== Potência ========================================

Px_w = sum(abs(X).^2) / length(X);
Px_dBm = 20*log10(Px_w*1e3) + 30;
Py_w = sum(abs(Y).^2) / length(Y);
Py_dBm = 20*log10(Py_w*1e3) + 30;

fprintf('\nPotência de x: %d [W]\n',Px_w);
fprintf('\nPotência de x: %d [dBM]\n',Px_dBm);
fprintf('\nPotência de y: %d [W]\n',Py_w);
fprintf('\nPotência de y: %d [W]\n',Py_dBm);

% =============== Plota alguns Graficos ================================ 

figure(1)   % Figura referente ao sinal de audio no tempo
subplot(2,1,1) % Plota o sinal de mensagem m1 no dominio do tempo e da frequencia
plot(t,x,'b'), grid, title ('Sinal de Audio'); 
xlabel('Tempo [s]'), ylabel('Ampl. [u.a.]')
axis tight

subplot(2,1,2), plot(t,y,'r'), grid on;     % Plota o sinal de áudio depois de filtrado
title ('Sinal de Audio Filtrado');
xlabel('Tempo [s]'), ylabel('Ampl. [u.a.]'), axis tight

figure(2)
subplot(2,1,1)
    plot(f,10*log10(fftshift(abs(X))),'b'), grid on; hold on
        title ('Espectro de Poténcia em Banda Base');
        xlabel('Frequencia[Hz]'), ylabel('PSD [dB/Hz]'), axis tight
subplot(2,1,2)
    plot(f,10*log10(fftshift(abs(Y))),'r'), grid on
        title ('Espectro de Poténcia em Banda Base');
        xlabel('Frequencia[Hz]'), ylabel('PSD [dB/Hz]'), axis tight
        
        figure(3)
subplot(2,1,1)
        plot(f,10*log10(fftshift(abs(P))),'b'), grid on; hold on
        title ('Espectro');
   
%sound(y,Fs);                % Reproduz o sinal y(t)