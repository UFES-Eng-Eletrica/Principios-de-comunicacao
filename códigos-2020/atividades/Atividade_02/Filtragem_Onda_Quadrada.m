%
% .... Exerc�cio para filtragem de uma onda quadrada .......
%


%% Inicializa��o do script
clc, clear all, close all

% Dados de entrada
ti  = 0;          % Instante inicial [s]
tf  = 0.4e-6;     % Instante final [s]
tam = 1024;       % Tamanho do vetor tempo [amostras]
A   = 1;          % Amplitude do sinal senoidal
fcorte1 = 0.01;    % Frequencia de corte do filtro  
ordem   = 21;     % Ordem do filtro passa baixas

%% Processamento

% Gera��o do vetor tempo
t = linspace(ti,tf,tam);

% Determina��o do periodo de amostragem [s]
ts = t(2) - t(1);

% Determina��o da taxa de amostragem [Amostras/s]
Fs = 1/ts;             % Taxa de amostragem

% Gera��o do puslo quadrado
x1 = zeros(size(t));
x1((end/2)-(end/8):(end/2)+(end/8)) = ones(size(x1((end/2)- (end/8):(end/2)+(end/8))));
%x1 = rectpuls(ts)

% Medi��o do Espectro
[X1,x1_n,f1,df1] = Analisador_de_Espectro(x1,ts);

% Plotagem dos sinais nos dom�nios do tempo e da frequencia
figure(1), plot(t,x1)   % no dom�nio do tempo
figure(2), plot(f1,fftshift(db(abs(X1))))   % no dom�nio da frequencia

% Gera��o do filtro passa baixas               
h = fir1(ordem,fcorte1); 
figure, freqz(h,1,tam)  % Plota a resposta do filtro

% Filtra o pulso quadrado no dom�nio do tempo
x1_filt = filter(h,1,x1);

% Medi��o do Espectro do sinal filtrado
[X1_filt,x1_filt_n,f2,df2] = Analisador_de_Espectro(x1_filt,ts);
figure(4), plot(f2,fftshift(db(abs(X1_filt))))   

% Filtra o pulso quadrado no dom�nio da frequencia
H_filt = fft(h,tam);                % Resposta em frequencia do filtro
X1_filt_freq = X1.*H_filt;          % Filtragem em si
x1_filt_freq = ifft(X1_filt_freq);  % de volta para o dom�nio do tempo

figure(4), hold all
plot(f1,fftshift(db(abs(X1))),'k-')
plot(f2,fftshift(db(abs(X1_filt_freq))),'--')
legend('Filtrado no dom�nio do tempo', 'Sinal original', ...
       'Filtrado no dom�nio da Frequencia')


%% Plotagem dos sinais filtrados e compara��o com o original
figure 
plot(t,x1./max(abs(x1)),'-')            % sinal original
hold all
plot(t,x1_filt./max(abs(x1_filt)),'.')  % sinal filtrado no tempo
hold all
plot(t,x1_filt_freq./max(abs(x1_filt_freq)),'--')  % sinal filtrado na freq
legend('sinal original', 'sinal filtrado no dominio do tempo', ...
       'sinal filtrado no dom�nio da frequencia')

% ------------------------------------------------------------------------
