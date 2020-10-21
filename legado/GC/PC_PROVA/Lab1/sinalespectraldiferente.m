% Alice Monteiro Gomes - Laboratório 1 - 05/04/2018
% Script para função
% Não utiliza a unção do professor
%% PARÂMETROS

ti = 0;                  % tempo inicial
tf = 1e-6;               % tempo final
pos = 1000;              % numero de posições do veto tempo
fat_amostragem = 25;     % fator de amostragem
A = 100;                 % amplitude do sinal snoidal

%% C�?LCULOS

% Gerando vetor tempo
t = linspace(ti,tf,pos);     % vetor tempo

% Cálculo do período de amostragem
ts = t(2) - t(1)             % período de amostragem

% Cálculo da taxa de amostragem
fs = 1/ts                    % Taxa de amostragem

% Cálculo da frequência de corte
fc = fs/fat_amostragem       % frequencia de corte

% Geração do sinal senoidal
x = A*sin(2*pi*fc*t);

% Equação para cálculo da Potência em dBm
Pdbm = 10*log10((A^2)/0.001)  % potencia em dBm

df = fs/pos;

f = (0:df:df*(pos)-1) - fs/2 ;

X = abs(fft(x));



%% PLOT 
figure(1)
plot(t,x,'r')                          % cor magenta e linha tracejada com marcador em círculo
%semilogx(t,x,'m--o')                  % coloca o eixo x em escala logarítmica
legend('Sinal senoidal');              % define legenda do gráfico
xlabel('tempo [s]');                   % define nome do eixo x
ylabel('Amplitude [u.a.]');            % define nome do eixo y
title('Geração de sinais senoidais');  % deine título do gráfico
grid  % coloca grade no gráfico

figure(2)
plot(f,fftshift(X/max(X)))

