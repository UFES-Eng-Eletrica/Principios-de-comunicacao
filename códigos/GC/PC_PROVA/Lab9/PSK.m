% Principio de Comunicação - Laboratório 9.
% Wagner Trarbach Frank

clear all; close all; clc;  % limpa Workspace, fecha imagens e limpa Command Window

% =====  Modulação Digital em Banda Base e Banda Passanteo ================
%          Banda Base: com pammod
%          Banda Passante: pskmod ou qammod

% ===============  Parametros de Simulação ================================
M      = 16;           % Nível da modulação +V e -V.
k      = log2(M);     % bits por símbolo
n      = 300000;        % Numero de bits da Sequencia (Bitstream)
nsamp  = 4;           % Taxa de Oversampling 
Ebn0 = 15;          % SNR = Ebn0 + 10log10[log2(M)] - 10log10(nsamp) +3
snr = Ebn0 + 10*log10(log2(M)) - 10*log10(nsamp) +3;
Fs     = 1e6;         % Bw = 1M Hz   

% =================== Calculos Preliminares ===============================
Ts = 1/Fs;                        % Periodo de amostragem         
Rb     = 1e6;                     % Taxa de bits por segundo;
Tb    = 1/Rb;                     % Tempo pra cada bit


% ================== Simulação do Sistema =================================

disp('...................................................................')
disp('............... Modulação Digital .................................')

% ========================= TRANSMISSÃO/MODULAÇÃO =========================

x = randi(M,n,1) - 1;     % Gera o Bitstream

xmod = pskmod(x,M);     % mapeamento

x_up = rectpulse(xmod,nsamp);  % Reamostragem (upsample)

Ts = 1/n;                         % Periodo de amostragem   

% ======================== CANAL ==========================================

y_ruido = awgn(x_up,snr,'measured');    % Adiciona ruído Gaussiano branco ao sinal

% =========================RECEPÇÃO =======================================

y_down = intdump(y_ruido,nsamp);    % Reamostragem (downsample)

t = (0:Ts:(length(y_down)-1)*Ts).';     % Gera o vetor tempo

% Demodulação (M-PSK)
y = pskdemod(y_down,M);       % Demapeamento

% ===================== Calcula os erros ==================================
d_bit    = (abs(x-y));
n_erros  = sum(d_bit);
ber_awgn = mean(d_bit);

% ==================== Calcula os espectros dos sinais ====================
[X,sinal_tf1,f1,df] = FFT_pot2(x_up.',Ts);  % Determina o espectro
[Y,sinal_tf2,f2,df] = FFT_pot2(y_down.',Ts);   % Determina o espectro

% ================== Plota os sinais no dominio do Tempo ==================
figure
plot(real(x_up(1:nsamp*50)))  % plota o sinal modulado
hold on
plot(real(y_ruido(1:nsamp*50)),'r')  % plota o sinal ruidoso
 
% % Mostra o diagram de olho na saída do canal
% if nsamp == 1
% offset = 0;
% h =  eyediagram(real(y_down),2,1,offset);
% else
% offset = 2;
% h =  eyediagram(real(y_down),3,1,offset);
% end
% set(h,'Name','Diagram de Olho sem Offset');
figure
subplot(2,1,1)
plot(f1,10*log10(fftshift(abs(X))),'b'), grid on; hold on
title ('Espectro do sinal modulado');
xlabel('Frequencia[Hz]'), ylabel('PSD [dB/Hz]'), axis tight
subplot(2,1,2)
plot(f2,10*log10(fftshift(abs(Y))),'r'), grid on
title ('Espectro do sinal ruidoso');
xlabel('Frequencia[Hz]'), ylabel('PSD [dB/Hz]'), axis tight

%Mostra o Diagrama de Constelação
scatterplot(y_down)
%************** Mostra Resultados Provisórios na Tela *********************

disp(sprintf('SNR: %4.1f dB',snr));
disp(sprintf('BER: %5.1e ',ber_awgn));
disp(sprintf('Qtd de erros: %3d',n_erros));