% An?lise de Fourier da Fun??o Triangular 
% 
% Para Principios Comunica??es I
% 
% by Prof. Jair Silva
% 
% =========================================================================

% Inicializa??o
clc, clear all, close all

% Variaveis Iniciais
t  = linspace(0,1e-6,10000);  % Vetor tempo
ta = t(2) - t(1);             % Intervalo de amostragem
fa = 1/ta;                    % "Frequencia de amostragem"
fc = fa/32;                   % frequencia central
To = 1/fc;                    % periodo fundamental
N  = 100;                     % Amostras do somat?rio
A  = 10;                      % Amplitude da onda triangular
n  = 2*To/ta;                 % qtd de amostras de 2 periodos de sinal
figure                        % cria uma figura

% Somat?rio das senoides
for k = 1:N
    num(k)   = 8*A*((-1)^(k+1));
    den(k)   = (pi^2)*((2*k-1)^2);
    fseno(k,:) = sin(2*pi*(2*k-1)*fc*t);
    x(k,:)   = (num(k)/den(k))*(fseno(k,:));
    plot(t,x(k,:)), hold all
end
title ('Ondas Senoidais')
xlabel('tempo [s]'), ylabel('Amplitude [u.a]'), grid
axis([0 t(64) -10 10])

% Onda triangular
xt = sum(x(:,:));
hold on, plot(t(1:n),xt(1:n),'r')

% Transformada de Fourier
[X,xn,f,df] = FFT_pot2(xt,ta);
figure, plot(f,10*log10(fftshift(abs(X)))), grid
title ('Espectro de Pot?ncia');
xlabel('Frequ?ncia[Hz]'), ylabel('PSD [dB/Hz]')
