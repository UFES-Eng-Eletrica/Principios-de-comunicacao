% .................... Princ?pios de Comunica??es I........................
% 
% Lab IV 
% 
% Modula??o FM     
%
% by Jair Silva
% UFES/2014
% .........................................................................
%
clc, clear all, close all
%
% ............... Dados de entrada ........................................
Fs = 50e3 ;       % Taxa de amostragem 
fo = 2000;        % Frequencia da portadora
fm = 440;         % Frequ?ncia do sinal modulante
A  = 1;           % Amplitude do sinal modulante
Eo = 1;           % Amplitude do sinal Modulado em FM
B  = 2;           % ?ndice de modula??o angular [rad] 
C  = 0;           % Fase inicial
d  = 1;           % Dura??o do sinal de mensagem


%................ Dados calculados .......................................
kf = (B*fm)/A;    % Constante de modula??o FM 
Df = kf*A;        % Desvio frequencia -- Quando o sinal modulante ? um tom
Bw = 2*Df + 2*fm; % Largura de banda do sinal modulado (Crit?rio de Carson)
 
% ............ Gera??o do sinal modulante ................................. 
t  = linspace(0, d, d*Fs+1);  % vetor tempo
ta = t(2);                    % Periodo de amostragem dos sinais em banda base
m  = A*cos(2*pi*fm*t);        % sinal de mensagem
% m  = A*cos(2*pi*fm*t) + A*cos(2*pi*0.5*fm*t);   % sinal de mensagem com 2 senoides

% ............ Modula??o FM ...............................................
s = Eo*fmmod(m,fo,Fs,kf); % Modulate both channels.

% ............... Canal ...................................................
r = s;  % B2B

% ............ Demodula??o FM .............................................
r_demod = fmdemod(r,fo,Fs,kf);
% r_demod = r_demod./max(abs(r_demod));


% ================ Plota alguns Gr?ficos ==================================
% Plota o sinal de mensagem m no dominio do tempo e da frequencia
[M,mn,f,df] = FFT_pot2(m,ta);  % Determina o espectro
figure(1)         
subplot(2,1,1)
plot(t,m,'b'), grid, 
title ('Sinal Modulador'); xlabel('tempo [s]'), ylabel('ampl. [u.a.]')
subplot(2,1,2)
plot(f,10*log10(fftshift(abs(M))),'b'), grid
title ('Espectro em Banda Base (Sinal Modulador)');
xlabel('Frequ?ncia[Hz]'), ylabel('PSD [dB/Hz]')


% Plota o sinal modulado no dominio do tempo e da frequencia
figure(2);   % transmiss?o
[S,sn,f,df] = FFT_pot2(s,ta);  % Determina o espectro
subplot(2,1,1)
plot(t,s,'g'); title ('Sinal Modulado'), xlabel('t [s]'); ylabel('Sinal modulado'); grid
subplot(2,1,2)
plot(f,10*log10(fftshift(abs(S))),'g');
title ('Espectro em Banda Passante (Sinal Modulado)');
xlabel('f [Hz]'); ylabel('Espectro do sinal modulado'); grid

% Plota gr?ficos comparativos nos dominios do tempo e da frequencia
figure(3);   % transmiss?o
[R,rn,f,df] = FFT_pot2(r,ta);  % Determina o espectro
subplot(2,1,1)
plot(t,s,'g.'); title ('Compara os sinais'), xlabel('t [s]'); ylabel('Sinais Modulados'); grid
hold on, plot(t,r,'r'), legend('Sinal Transmitido','Sinal Recebido')
subplot(2,1,2)
plot(f,10*log10(fftshift(abs(S))),'g.');
title ('Compara os Espectros');
xlabel('f [Hz]'); ylabel('Espectro do sinal modulado'); grid
hold on, plot(f,10*log10(fftshift(abs(R))),'r'); legend('Sinal Transmitido','Sinal Recebido')

% Plota gr?ficos comparativos nos dominios do tempo e da frequencia
[Rd,rdn,f,df] = FFT_pot2(r_demod,ta);  % Determina o espectro
figure(4)         
subplot(2,1,1)
plot(t,m,'b.'), grid
hold on, plot(t,r_demod,'k')
title ('Compara os sinais'); xlabel('tempo [s]'), ylabel('ampl. [u.a.]')
legend('Sinal na Fonte','Sinal no Destino')
subplot(2,1,2)
plot(f,10*log10(fftshift(abs(M))),'b.'), grid
hold on, plot(f,10*log10(fftshift(abs(Rd))),'k')
title ('Compara os Espectros');
xlabel('Frequ?ncia[Hz]'), ylabel('PSD [dB/Hz]')
legend('Sinal na Fonte','Sinal no Destino')
%
%