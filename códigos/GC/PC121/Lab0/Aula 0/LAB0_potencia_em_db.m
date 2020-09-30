% Principio de Comunicação - Aula 0.
% Wagner Trarbach Frank

% Parametros do sistema;
Pwm = 0.001; % Valor do Pwm.
Ti = 0; % Valor inicial do intervalo de tempo.
Tf = 0.4e-6; % Valor final do intervalo de tempo.
amostras = 100; % Valor de amostras no intervalo de tempo.

t = linspace(Ti,Tf,amostras); % vetor tempo

% Periodo de amostragem:
Ta = t(2) - t(1); % Calculo do periodo de amostragem.

% Calculo da taxa de amostragem:
Fa = 1/Ta % calculo da taxa de amostragem.
% Calculo da Potencia em dbmu:
Pdbm = 10*log10(Pwm/0.001);  % Calculo da potencia em dbm.

x = sin(pi);

% PLotagem dos sinais
plot(t,x)