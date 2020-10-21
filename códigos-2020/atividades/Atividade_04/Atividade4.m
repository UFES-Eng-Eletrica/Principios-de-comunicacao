
%% Inicialização do script
clc, clear all, close all

% Dados de entrada
ti  = 0;          % Instante inicial [s]
tf  = 1;     % Instante final [s]
tam = 1024;       % Tamanho do vetor tempo [amostras]
A   = 1;          % Amplitude do sinal senoidal
fcorte1 = 0.01;    % Frequencia de corte do filtro  
ordem   = 21;     % Ordem do filtro passa baixas

%% Processamento

%% Geração do vetor tempo
t = linspace(ti,tf,tam);

%% Determinação do periodo de amostragem [s]
ts = t(2) - t(1);

%% Determinação da taxa de amostragem [Amostras/s]
Fs = 1/ts;             % Taxa de amostragem

%% Geração do pulso quadrado (sinal modulante ou modulador)

x1 = zeros(size(t));
x1((end/2)-(end/8):(end/2)+(end/8))=ones(size(x1((end/2)- (end/8):(end/2)+(end/8))));

% Plot onda quadrada
figure()
plot(t,x1);
xlabel('tempo (s)')
ylabel('Amplitude (u.a.)')
title('Pulso Retangular')

%% Análise Espectral
[Z,z_n,f,df] = Analisador_de_Espectro(x1,ts);
Y = fftshift(Z);

figure()
plot(f,10*log10(abs(Y)))
xlabel('frequência(Hz)');
ylabel('PSD (dB/Hz)');
title('Espectro do sinal')

%% Geração da portadora
Ac = 1; %Amplitude da portadora
fc = 60;%frequência da portadora
c = Ac*cos(2*pi*fc*t);

figure()
plot(t,c);
xlabel('tempo (s)')
ylabel('Amplitude (u.a.)')
title('Portadora')

%% Modulação de Amplitude (AM)

y = x1.*c; %modulador de produto

figure()
plot(t,y);
xlabel('tempo (s)')
ylabel('Amplitude (u.a.)')
title('Sinal Modulado')

[Zm,z_n,f,df] = Analisador_de_Espectro(y,ts);
Ym = fftshift(Zm);

figure()
plot(f,10*log10(abs(Ym)))
xlabel('frequência(Hz)');
ylabel('PSD (dB/Hz)');
title('Espectro do sinal')


