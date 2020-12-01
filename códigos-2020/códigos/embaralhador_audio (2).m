%--------------------------------------------------------------------------
% Gustavo Rossi Martins
% 22/10/2020
% Princípio de Comunicações
%--------------------------------------------------------------------------
%% Inicialização
clc, clear, close all

%% Geração do Sinal Modulante
[x,Fs] = audioread('Beethoven_Sinfonia_5.wav');
tam = 2^19;      % Quantidade de amostras
x = x(1:tam);

% FREQUÊNCIAS IMPORTANTES PARA A MODULAÇÃO
Fmax = Fs/2;    % Frequência máxima do sinal x(t)
Fc = Fmax;   % Frequência da Portadora (>> max freq do sinal)

ts = 1/Fs;  % Período de Amostragem (s)

t = 0:ts:(tam-1)*ts; % Vetor tempo

% Espectro do Sinal Modulante
[X,x_tf,f,df] = Analisador_de_Espectro(x,ts);

%% Gráfico do sinal
figure(1)
subplot(2,1,1)
    plot(t,x);
    title('Sinal Modulador');
    xlabel('Tempo (s)');
    ylabel('Amplitude (u.a.)')
subplot(2,1,2)
    plot(f,db(abs(fftshift(X)),'power'));
    title('Espectro do Sinal Modulador');
    xlabel('Frequência (Hz)');
    ylabel('DSP (dB/Hz)');

%% CIRCUITO DE SIGILO
% Modulação de Amplitude (AM)
% Modulação AM-DSB/SC

% Sinal Modulado
% O resultado já está cortado para frequências acima da Fcorte já que para
% o Fs usado, e para os comandos usado, o matlab não mostra todo o espectro
% após modulação. Para isso, é necessário usar outro comando para leitura
% do audio, definindo o Fs diretamente.

y = ammod(x,Fc,Fs);

% Espectro do sinal em sigilo
[Y,y_ft,f,df] = Analisador_de_Espectro(y,ts);

figure(2)
subplot(2,1,1)
    plot(t,y)
    title('Sinal Cripitografado (AM)')
    xlabel('Tempo (s)')
    ylabel('Amplitude (u.a.)');
subplot(2,1,2)
    plot(f,db(abs(fftshift(Y)),'power'))
    title('Espectro do Sinal Cripitografado')
    xlabel('Frequência (Hz)')
    ylabel('Densidade Espectral de Potência (dB/Hz)');

%% CIRCUITO DE desSIGILO

% Sinal Descriptografado
z = ammod(y,Fc,Fs);

% Espectro do Sinal Descriptografado
[Z,z_tf,f,df] = Analisador_de_Espectro(z,ts);

% Gráfico do sinal
figure(3)
subplot(2,1,1)
    plot(t,z); hold on;
    title('Sinal Descriptografado');
    xlabel('Tempo (s)');
    ylabel('Amplitude (u.a.)');
subplot(2,1,2)
    plot(f,db(abs(fftshift(Z)),'power'));
    title('Espectro do Sinal Descriptografado');
    xlabel('Frequência (Hz)');
    ylabel('DSP (dB/Hz)');

