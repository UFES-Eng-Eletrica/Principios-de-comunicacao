% Principio de Comunicação - Aula 0.
% Wagner Trarbach Frank

% Função seno

% Parametros do sistema;
Ti = 0; % Valor inicial do intervalo de tempo.
Tf = 0.4e-6; % Valor final do intervalo de tempo.
amostras = 100; % Valor de amostras no intervalo de tempo.
fat= 25; % Fator de amostragem
A = 1; % Amplitude 

% Geração do vetor tempo:
t = linspace(Ti,Tf,amostras); % vetor tempo.

% Periodo de amostragem:
Ta = t(2) - t(1); % Calculo do periodo de amostragem.

% Calculo da taxa de amostragem:
fa = 1/Ta; % calculo da taxa de amostragem onde fa >= 2*fmax

% Calculo da frequencia:
fc = fa/fat;

% Geração de uma função seno x(t) = Asen(2*pi*fc*t)
x = A*sin(2*pi*t*fc);

% PLotagem dos sinais
plot(x)
grid