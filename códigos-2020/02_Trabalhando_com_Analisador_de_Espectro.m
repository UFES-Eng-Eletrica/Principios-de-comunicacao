%                                                                         %
% =========================================================================
%                                                                         %
%                    - Principios Comunicaçoes I -                        %
%    ----------  Embaralhador e Desembaralhador de Audio   -------------  %
%          ......... Com um sinal de Audio   ............                 %
%                                                                         %
% by Prof. Jair Silva                                                     %
%                                                                         %
% =========================================================================

% Feito por Ricardo Vieira


%% Inicializaçao
clc, clear all, close all

%% ===============  Sinal de Audio de Simula��o ==============================
load handel.mat %Carregando
sound(y,Fs) %Sente o som
%y = y.';%Transpondo a matriz sem conjulgar o complexo

%% ===============  Parametros de Simulaçao ==============================
Fc      = 2e3;     % Frequencia Central da Modulaçao 
snr     = 100;      % Relaçao Sinal-Ruido

%% --------- Primeira parte - Calculos Preliminares ----------------------
dt        = 1/Fs;                          % Periodo de amostragem                              
t         = (0:dt:(length(y)-1)*dt).';     % Gera o vetor tempo
% fc1 = 1000;             % Frequencia central do primeiro sinal (Banda Base)
% m  = sin(2*pi*fc1*t);   % primeiro sinal a ser multiplexado 
% ------------------------------------------------------------------------


%% ---------- Segunda Parte: Modula o Sinal de audio  ---------------------
s = ssbmod(y,Fc,Fs);                     % Modula o sinal de Audio
                                         % O Filtro passa baixa 
                                         % implementado internamente 
% ------------------------------------------------------------------------

%############### Quarta Parte - Canal Ruidoso ############################

s_ruidoso = awgn(s,snr,'measured');

%% ---------- Quinta Parte - Desembaralha o Sinal de Audio  ---------------------
s_r = ssbmod(s_ruidoso,Fc,Fs);  % Agora Modula o sinal Audio Recebido


% -------------------------------------------------------------------------

%% ------------------------- Analisador de Espectro
[Sinal_ff,sinal_tf,f,df] = FFT_pot2(y.',1/Fs) ;


%% --------------------- Plotagem dos sinais

figure; plot(t,y);
ylabel('Amplitude do sinal de audio (u.a)');
xlabel('TEmpo [s]');

figure; plot(f, 10*log10(abs(fftshift(Sinal_ff))));
xlabel('Frequencia [Hz]')
ylabel('Densidade de potencia [dB/Hz]')