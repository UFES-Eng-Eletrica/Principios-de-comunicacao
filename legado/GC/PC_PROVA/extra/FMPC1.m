% .................... Princ?pios de Comunica??es I........................
% 
% Lab IV 
% 
% Modula??o FM   - Segunda parte   
%
% by Jair Silva
% UFES/2013
% .........................................................................
%
clc, clear all, close all
%
% ............... Dados de entrada ........................................
fm = 440;         % Frequ?ncia do sinal modulante
Fc = 2000;        % Frequencia da portadora
fs = 50e3 ;       % Taxa de amostragem 
A  = 1;           % Amplitude do sinal modulante
B  = 1000;       % ?ndice de modula??o angular 
kf = 1;           % ?ndice de modula??o
C  = 0;           % Fase inicial
d  = 1 ;          % Dura??o do sinal de mensagem

%................ Dados calculados .......................................
kf  = (B*fm)/A;   % Constante de modula??o FM 
delta_f = kf*A;   % Desvio frequencia -- Quando o sinal modulante ? um tom
Bw  = 2*delta_f + 2*fm % Largura de banda do sinal modulado (Carson)
 
% ............ Gera??o do sinal modulante ................................. 
t = linspace(0, d, d*fs+1);   % sinal tempo
m = .5*cos(2*pi*fm*t);        % sinal mensagem

% ............ Modula??o FM ...............................................
s_int = cumsum(m)/fs;                     % Computa a integra??o 
s     = A*cos(2*pi*Fc*t + B*s_int + C);   % modula??o

% ............... Canal ...................................................
r = s;  % B2B

% ............ Demodula??o FM .............................................
% Executa a derivada do sinal modulado em FM
r_derv = diff(r);             

% Filtragem butterworth filter parameter
N      = 8 ;            % ordem do filtro
fcut   = Fc/2;          % frequencia de corte do filtro 
r_abs  = abs(r_derv);   % tira o valor absoluto do sinal modulado  
[b,a]  = butter(N,2*fcut/fs,'low');  % Filtro butterworth 
figure, freqz(b,a,fcut,fs),title('frequency responce of the LPF');
r_filt = filter(b,a,r_abs);          % Filtragem

% Remove m?dias 
r_sm = r_filt - mean(r_filt);

% Normaliza o sinal 
r_demod = r_sm/max(abs(r_sm));


% ================ Plota alguns Gr?ficos ==================================
figure;   % transmiss?o
f = linspace(-fs/2, fs/2, length(s));
S = fft(s);
subplot(2,1,1); plot(t,s); xlabel('t [s]'); ylabel('Sinal modulado');

subplot(2,1,2); plot(f,10*log10(fftshift(abs(S))));
xlabel('f [Hz]'); ylabel('Espectro do sinal modulado');

figure;   % Receptor
R = fft(r_demod);
subplot(2,1,1); plot(t(1:end-1),r_demod); xlabel('t [s]'); ylabel('Sinal Demodulado');

subplot(2,1,2); plot(f(1:end-1),10*log10(fftshift(abs(R))));
xlabel('f [Hz]'); ylabel('Espectro do sinal Demodulado');

figure;   % compara os sinais original e demodulado
subplot(2,1,1); plot(t,m,'b-',t(1:end-1),(-1)*r_demod,'r--')
subplot(2,1,2); plot(f,10*log10(fftshift(abs(fft(m)))),'b-',...
                     f(1:end-1),10*log10(fftshift(abs(R))),'r--');

% Para escutar os sinais 
%fprintf('Play do sinal original \n');
%sound(m, fs);
%fprintf('Play do sinal demodulado \n');
%sound(r, fs);