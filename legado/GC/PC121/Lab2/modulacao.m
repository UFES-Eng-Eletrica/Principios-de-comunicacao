% Principio de Comunicação - Aula 2.
% Wagner Trarbach Frank
% PArte 3.2 modulação

% Parametros de entrada
dt = 0.002;      % Intervalo de amostragem
T  = 6;          % Periodo da fun��o geradora
M  = 3;          % Qtd de periodos do sinal 

% Gera o vetor tempo
t  = [0:dt:T-dt];

% Periodo de amostragem:
ta = t(2) - t(1); % Calculo do periodo de amostragem.
 
% Gera os sinais - pulso quadrado e pulso quadrado modulado
x1 = zeros(size(t));    % Cria um vetor de zeros
x1((end/2)-(end/8):(end/2)+(end/8))= ones(size(x1((end/2)- (end/8):(end/2)+(end/8))));  % Criação de uma onda quadrada.
x2 = x1.*sin(2*pi*60*t);    % multiplicação por uma senoide de frequencia 60hz

% Calcula os espectros dos sinais - pulso quadrado e pulso quadrado modulado 
[X1,xn1,f,df] = FFT_pot2(x1,dt);    % calcula a FFT para x1
[X2,xn2,f,df] = FFT_pot2(x2,dt);    % calcula a FFT para x2

% PLotagem dos sinais 
figure, plot(t,x1), hold all, plot(t,x2,'--');
title('Gráfico da onda quadrada e modulada no tempo')
legend('Onda quadrada','Onda quadrada x seno');
figure, plot(f,10*log10(fftshift(abs(X1)))), hold all
plot(f,10*log10(fftshift(abs(X2)))), grid
title('Gráfico da onda quadrada e modulada na frequencia')
legend('Frequencia da onda quadrada','Frequencia da onda quadrada*seno');