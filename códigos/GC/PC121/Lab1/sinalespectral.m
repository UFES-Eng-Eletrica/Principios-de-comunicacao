% Principio de Comunicação - Aula 2.
% Wagner Trarbach Frank
% Sinal Espectral

% Parametros do sistema;
Ti = 0; % Valor inicial do intervalo de tempo.
Tf = 1e-6; % Valor final do intervalo de tempo.
amostras = 1000; % Valor de amostras no intervalo de tempo.
A = 1; % Amplitude 
fat = 100;     % fator de amostragem

% Geração do vetor tempo:
ts = linspace(Ti,Tf,amostras); % vetor tempo.

% Periodo de amostragem:
ta = ts(2) - ts(1); % Calculo do periodo de amostragem.

% Calculo da taxa de amostragem:
fa = 1/ta; % calculo da taxa de amostragem onde fa >= 2*fmax

% Calculo da frequencia:
fc = fa/fat;    % frequencia de corte.

% Vetor frequencia
f = (0:fc:fc*(amostras-1) - fa/2); %Aumentar a frequencia(f), significa diminuir o valor do fator. O sinal
%fica mais distorcido.

% Geração de uma função seno x(t) = Asen(2*pi*fc*t)
x = A*sin(2*pi*fc*ts);

% Calculo da Potencia em dbmu:
Pdbm = 10*log10(A^2/0.001)  % Calculo da potencia em dbm do sinal gerado.

% PLotagem dos sinais
[sinal_ff,sinal_tf,f,fc] = FFT_pot2(x,ta) 

plot(f,(fftshift(abs(sinal_ff))));
figure
plot(ts,x);
grid;