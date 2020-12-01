% ========================================================================%
%                    Principios de Comunicações I                         %
%             ---------- Modulação AM-DSB/SC -----------                  %
%                                                                         %
%  Nathalia Silva Santana                                                 %
% =========================================================================

%% Inicialização
clc, clear all, close all;

%% Geracao do sinal modulante
Fs = 300;             % taxa de amostragem (amostras/s)
tam = 2^18;           % quantidade de amostras de cada variavel
ts = 1/Fs;            % periodo de amostragem 
t = 0:ts:(tam-1)*ts;  % geracao do vetor tempo
fm1 = 1;              % frequencia da primeira senoide
fm2 = 2;              % frequencia da segunda senoide

x = sin(2*pi*fm1*t) + sin(2*pi*fm2*t);   % sinal modulador

% Medicao do espectro do sinal modulante
[X,x_tf,f,df] = Analisador_de_Espectro(x,ts);

%% Geracao da portadora da transmissao
Ac = 1;        % amplitude da portadora nao modulada 
fc = 10*fm2;   % frequencia da portadora (muito maior que a maxima frequencia do sinal modulador)
ct = Ac*cos(2*pi*fc*t);   % portadora de transmissao (nao modulada)

% Medicao do espectro da portadora de transmissao
[CT,ct_tf,f,df] = Analisador_de_Espectro(ct,ts);

%% Modulação de Amplitude (AM)
y = x.*ct;   % modulador de produto

[Zm,z_n,f,df] = Analisador_de_Espectro(y,ts);
Ym = fftshift(Zm);

%% Demodulacao com deteccao coerente 
% Geracao da portadora de recepcao
cr = Ac*cos(2*pi*fc*t);  % portadora de recepcao em coerencia de frequencia e fase com a portadora de transmissao
z = y.*cr;   

% Medicao do espectro da portadora de recepcao
[Zm,z_n,f,df] = Analisador_de_Espectro(z,ts);
Zm = fftshift(Zm);

%% Plotagem
figure(1)
subplot(2,1,1)
plot(t,x), title('Sinal modulador')
xlabel('Tempo (s)'), ylabel('Amplitude (u.a)');
subplot(2,1,2)
plot(f, 10*log10(fftshift(abs(X)))), title('Espectro do sinal');
xlabel('Frequencia(Hz)')
ylabel('Densidade espectral de potencia(dB/Hz)')

figure(2)
subplot(2,1,1)
plot(t,ct), title('Portadora de transmissao')
xlabel('Tempo (s)'), ylabel('Amplitude (u.a)');
subplot(2,1,2)
plot(f, 10*log10(fftshift(abs(CT)))), title('Espectro do sinal')
xlabel('Frequencia(Hz)')
ylabel('Densidade espectral de potencia(dB/Hz)')

figure(3)
subplot(2,1,1)
plot(t,y), title('Sinal Modulado')
xlabel('tempo (s)'), ylabel('Amplitude (u.a.)')
subplot(2,1,2)
plot(f,10*log10(abs(Ym))), title('Espectro do sinal')
xlabel('frequência(Hz)'), ylabel('PSD (dB/Hz)');

figure(4)
subplot(2,1,1)
plot(t,z), title('Sinal Demodulado')
xlabel('tempo (s)'), ylabel('Amplitude (u.a.)')
subplot(2,1,2)
plot(f,10*log10(abs(Zm))), title('Espectro do sinal')
xlabel('frequência(Hz)'), ylabel('PSD (dB/Hz)');







