% .................... Princípios de Comunicações I........................
% Lab V
% Modulação FM
% Wagner Trarbach Frank
% .........................................................................
clc, clear all, close all;
% ............... Dados de entrada ........................................
fm = 440; % Frequência do sinal modulante
Fc = 2000; % Frequencia da portadora
fs = 50e3 ; % Taxa de amostragem
A = 1; % Amplitude do sinal modulante
B = 10000; % Índice de modulação angular
C = 0; % Fase inicial
d = 1 ; % Duração do sinal de mensagem
snr    = 3;           % Vetor SNR em dB 
%................ Dados calculados .......................................
kf = (B*fm)/A; % Constante de modulação FM
delta_f = kf*A; % Desvio frequencia -- Quando o sinal modulante é um tom
% ............ Geração do sinal modulante .................................
t = linspace(0, d, d*fs+1); % sinal tempo
m = .5*cos(2*pi*fm*t); % sinal mensagem
% ............ Modulação FM ...............................................
s_int = cumsum(m)/fs; % Computa a integração
s = A*cos(2*pi*Fc*t + B*s_int + C); % modulação
% ............... Canal ...................................................
%r = s; % B2B
r = awgn(s,snr,'measured');    % Adiciona ruÃ­do Gaussiano branco ao sinal

% ............ Demodulação FM .............................................
% Executa a derivada do sinal modulado em FM
r_derv = diff(r);
% Filtragem butterworth filter parameter
N = 8 ; % ordem do filtro
fcut = Fc/2; % frequencia de corte do filtro
r_abs = abs(r_derv); % tira o valor absoluto do sinal modulado
[b,a] = butter(N,2*fcut/fs,'low'); % Filtro butterworth
figure, freqz(b,a,fcut,fs),title('frequency responce of the LPF');
r_filt = filter(b,a,r_abs); % Filtragem
% Remove médias
r_sm = r_filt - mean(r_filt);
% Normaliza o sinal
r_demod = r_sm/max(abs(r_sm));
% ================ Plota alguns Gráficos ==================================
figure; % transmissão
f = linspace(-fs/2, fs/2, length(s));
S = fft(s);
subplot(2,1,1); plot(t,s); xlabel('t [s]'); ylabel('Sinal modulante');
subplot(2,1,2); plot(f,10*log10(fftshift(abs(S))));
xlabel('f [Hz]'); ylabel('Espectro do sinal modulante');
figure; % Receptor
R = fft(r_demod);
subplot(2,1,1); plot(t(1:end-1),r_demod); xlabel('t [s]'); ylabel('Sinal Demodulado');
subplot(2,1,2); plot(f(1:end-1),10*log10(fftshift(abs(R))));
xlabel('f [Hz]'); ylabel('Espectro do sinal Demodulado');
figure; % compara os sinais original e demodulado
subplot(2,1,1); plot(t,m,'b-',t(1:end-1),(-1)*r_demod,'r--')
subplot(2,1,2); plot(f,10*log10(fftshift(abs(fft(m)))),'b-',...
 f(1:end-1),10*log10(fftshift(abs(R))),'r--');
% Para escutar os sinais
fprintf('Play do sinal original \n');
sound(m, fs);
fprintf('Play do sinal demodulado \n');
sound(r, fs);