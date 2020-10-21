% Principio de Comunicação - Aula 2.
% Wagner Trarbach Frank
% Sinal Espectral

% Parametros do sistema;
Ti = 0; % Valor inicial do intervalo de tempo.
Tf = 1e-6; % Valor final do intervalo de tempo.
amostras = 1000; % Valor de amostras no intervalo de tempo.
A = 1; % Amplitude 
fat = 100;     % fator de amostragem


% Calculo da Potencia em dbmu:
Pdbm = 10*log10(A^2/0.001)  % Calculo da potencia em dbm do sinal gerado.

% PLotagem dos sinais
[sinal_ff,sinal_tf,f,fc] = FFT_pot2(x,ta) 

plot(f,(fftshift(abs(sinal_ff))));
figure

grid;