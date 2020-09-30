% PC I - Laboraório 0 - 29/03/2018
% Wagner Trarbach Frank
% Exemplo de script
% Esse código gera um vetor tempo com 0.4 de duração contendo 100 posições
% Teorema de Amostragem de Nyquist

%% PARÂMETROS

% Definição dos parâmetros
ti = 0;                  % tempo inicial
tf = 0.4e-6;             % tempo final
pos = 100;               % quantidade de posições no vetor
fat_amostragem = 2;     % fator de amostragem
fc = fa/fat_amostragem   % frequencia de corte
A = 1;                   % amplitude do sinal


%% C�?LCULOS


% Gerando vetor tempo
t = linspace(ti,tf,pos)  % vetor tempo

% Cálculo do período de amostragem
ta = t(2) - t(1)         % período de amostragem

% Cálculo da taxa de amostragem
fa = 1/ta                % taxa de amostragem

% Geração do sinal
x = A*sin(2*pi*fc*t);


%% PLOT 
plot(t,x)
grid  % coloca grade no gráfico
