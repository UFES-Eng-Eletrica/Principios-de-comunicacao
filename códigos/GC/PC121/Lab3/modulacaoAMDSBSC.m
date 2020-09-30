% .................... Princípios de Comunicações I .......................
%
% Lab III
% Modulação AM - Detector coerente
% Wagner Trarbach Frank
% .........................................................................
%
clc, clear all, close all;
%
% ----- Sinal Modulador - 2 Senoides a taxa Fs amostras por segundo -------
Fs = 100; % Taxa de amostragem
t = [0:2*Fs+1]'/Fs; % Vetor tempo
x = sin(2*pi*t) + sin(4*pi*t); % O sinal é a soma dos senóides
Nf = 2^18; % Tamanho da FFT
f = (0:Nf-1)'/Nf*Fs; % Vetor Frequência
X = abs(fft(x, Nf)); % Espectro do sinal modulador
% Plota o sinal Modulador
figure(1), subplot(211), plot(t,x)
title('Sinal Modulador')
xlabel('Tempo (seg)')
subplot(212), plot(f, X)
ax = axis; axis([0 Fs/2 ax(3) ax(4)]); % Plota metade da taxa de amostragem
title('Espectro do sinal Modulador')
xlabel('Frequencia (Hz)')
% ---- Cria a portadora de frequência -------------------------------------
fc = 20;
Ac = 1;
port = Ac * cos(2*pi*fc*t); % Portadora não modulada
% -------- Modulação AM ---------------------------------------------------
smod = x .* port; % sinal modulado
SMOD = fft(smod, Nf); % espectro do sinal modulado
figure(2)
subplot(211), plot(t,smod)
title('Sinal Modulado em AM')
xlabel('Tempo (seg.)')
subplot(212), plot(f, abs(SMOD))
ax = axis; axis([0 Fs/2 ax(3) ax(4)]);
title('Espectro do sinal Modulado')
xlabel('Frequencia (Hz)')
% ------- Demodulador Coerente --------------------------------------------
phi = 0;%pi/6; % Desvio de fase
OL = cos(2*pi*fc*t + phi); % Oscilador Local
sdemod = smod .* OL; % Demodulação
% Projeta o filtro passa baixa para remover os componentes perto de 2*fc Hz
Fcorte = 25; % Fcorte = freq. de corte de -3 dB em Hz
ordem = 5; % ordem = ordem do filtro.
Fnorm = Fcorte/(Fs/2); % Frequência de corte normalizada em Fs
[b,a] = butter(ordem, Fnorm); % Gera o filtro digital Butterworth
sdemod_bb = filter(b, a, sdemod); % Aplica o filtro
sdemod_bb = sdemod_bb - mean(sdemod_bb); % Remove o valor DC
SDEMOD = fft(sdemod_bb, Nf); % Espectro do sinal
figure (3), subplot(211), plot(t,sdemod_bb)
title('Saída do detector de envoltória')
xlabel('Tempo (seg.)')
subplot(212)
plot(f, abs(SDEMOD))
ax = axis;
axis([0 Fs/2 ax(3) ax(4)]);
title('Espectro do sinal na saída do detector')
xlabel('Frequencia (Hz)')
% Compara os sinais de mensagem transmitido e recebido
r = sdemod_bb.*max(abs(x));
figure(4), plot(t(1:end-5),x(1:end-5),t(1:end-5),r(1:end-5))