%% ========== Sistema de modulacao digital PAM ==========
%
%
% Lab06 - Simulando um sistema de comunicao utilizando modulacao PAM

clc; close all; clear all;

% =========================== Parametros ===========================

M      = 2;             % Nível da modulação (quantos niveis de tensao existe
                        % para representar o sinal)
k      = log2(M);       % bits por símbolo
n      = 3000;          % Numero de bits da Sequencia (Bitstream)
nsamp  = 4;             % Taxa de Oversampling
snr    = 25;             % Vetor SNR (relacao sinal-ruido) em dB
Rb     = 1e6;           % taxa de sinalizacao (transmissao) em [bits/seg]

%========================= Simulação do Sistema ===========================

disp('...................................................................')
disp('............... Modulação Digital .................................')

% ========================= TRANSMISSÃO =========================

% Gera o Bitstream
x = randi([0 M-1],1,n);

% Modulação
xmod = pammod(x,M);     % mapeamento

% Reamostragem (upsample)
x_up = rectpulse(xmod,nsamp);

% ========================= CANAL =========================
% Adiciona ruído Gaussiano branco ao sinal
y_ruido = awgn(x_up,snr,'measured');

% ========================= RECEPÇÃO =========================
% Reamostragem (downsample)
y_down = intdump(y_ruido,nsamp);
% Demodulação

% Demodulação (M-PAM)
y = pamdemod(y_down,M);       % Demapeamento


%========================= Calcula os erros =========================
d_bit= (abs(x-y));
n_erros  = sum(d_bit);
ber_awgn = mean(d_bit);

%========================= Calculo do espectro do sinnal=========================
ts=(1/Rb)/nsamp;
[Y,y2,f,df]=FFT_pot2(y_ruido,ts);

% ========================= Plots =========================
% Plota os sinais no dominio do Tempo
figure
plot(real(x_up(1:nsamp*50)))  % plota o sinal modulado
hold on
plot(real(y_ruido(1:nsamp*50)),'r')  % plota o sinal ruidoso

% Mostra o diagram de olho na saída do canal
if nsamp == 1
    offset = 0;
    h =  eyediagram(real(y_down),2,1,offset);
else
    offset = 2;
    h =  eyediagram(real(y_down),3,1,offset);
end

set(h,'Name','Diagram de Olho sem Offset');

% Mostra o Diagrama de Constelação
scatterplot(y_down)

% Plotando o espectro do sinal ruidoso na saida
figure(4)
plot(f,10*log10(fftshift(abs(Y))));
xlabel('f[Hz]')
ylabel('Amplitude [dB]') 
title('Espectro do sinal ruidoso na saida em dB')
grid on


% ========================= Mostra Resultados Provisórios na Tela =========================

disp(sprintf('SNR: %4.1f dB',snr));
disp(sprintf('BER: %5.1e ',ber_awgn));
disp(sprintf('Qtd de erros: %3d',n_erros));

disp('...................................................................')
%