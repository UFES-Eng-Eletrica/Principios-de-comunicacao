\%                                                                         
%                                                                         %
%                  - Principios Comunicações I -                          %
%    ----------  Gravação deum arquivo de áudio   -------------           %
%                                                                         %
%   Por Aiury Jureswski                                                   %
%                                                                         %
%                                                                         

%% -*-&-*-&-$-&-*-&-*- Inicialização -*-&-*-&-$-&-*-&-*- 
%clc, clear all, close all
clc, clear variables
% close all

%% -*-&-*-&-$-&-*-&-*- Geração do sinal modulante -*-&-*-&-$-&-*-&-*- 
Fs = 300;               % Taxa de amostragem (amostras/s);
tam = 2^18;             % Quantidade de amostras de cada variavel
ts = 1/Fs;              % Periodo de amostragem
t = 0:ts:(tam-1)*ts;    % Geração do vetor tempo
fm1 = 1;                % Frequência da primeira senoide
fm2 = 2;                % Frequência da segunda senoide

% Sinal modulador
x = sin(2*pi*fm1*t) + sin(2*pi*fm2*t); 

% Medição do especrtro do sinal modulante
[X, X_tf, ~, ~] = Analisador_de_Espectro(x,ts);

%% -*-&-*-&-$-&-*-&-*- Geração da portadora da transmissão -*-&-*-&-$-&-*-&-*- 
Ac = 1;                 % Amplitude da portadora não modulada
fc = 10*fm2;            % Frequência da portadora muito maior que a máxima 
                        % frequencia do sinal modulador

% Portadora de transmissão
ct = Ac*cos(2*pi*fc*t);

% Medição do espectro da portadora
[CT, ct_tf, ~, ~] = Analisador_de_Espectro(ct,ts);

%% -*-&-*-&-$-&-*-&-*- Modulação de Amplitude (AM) -*-&-*-&-$-&-*-&-*- 
y = x.*ct + 4*ct; %modulador de produto

[Ym,y_tf, ~, ~] = Analisador_de_Espectro(y,ts);
Ym = fftshift(Ym);

%% -*-&-*-&-$-&-*-&-*- Demodulação com detecção coerente -*-&-*-&-$-&-*-&-*- 
% Geração da portadora de recepção
cr = Ac * cos(2*pi*fc*t);           % Portadora de recepção em coerência de 
                                    % frequência e fase com a portadora 
                                    % de transmissão
z = y.*cr;  

% Medição do espectro da portadora de recepção
[Z,z_tf,~,~] = Analisador_de_Espectro(z,ts);
Z = fftshift(Z);

%% -*-&-*-&-$-&-*-&-*- Filtragem do sinal -*-&-*-&-$-&-*-&-*- 
fcorte1 = (fc/20)/(Fs/2);                % Frequencia de corte do filtro  
ordem = 21;                         % Ordem do filtro passa baixas

% Geração do filtro passa baixas               
h = fir1(ordem,fcorte1); 
% figure, freqz(h,1,tam)  % Plota a resposta do filtro

% Filtra sinal demodulado no dominio de tempo (convolucao)
z_filt = 2*filter(h,1,z);

% Medição do espectro do sinal demodulado e filtrado
[Z_filt,z_filt_tf,f,df] = Analisador_de_Espectro(z_filt,ts);
Z_filt = fftshift(Z_filt);

%% -*-&-*-&-$-&-*-&-*- Plotagem dos sinais -*-&-*-&-$-&-*-&-*- 
% Sinal modulador
figure(1)

subplot(2,1,1)
plot(t,x);
title("Fig.1 - Sinal modulador no tempo");
xlabel("Tempo (s)")
ylabel("Amplitude (u.a)")
axis([0 8 -2 2]);

subplot(2,1,2)
plot(f, 10*log10(fftshift(abs(X))));
title("Fig.2 -  Espectro do sinal modulador");
xlabel("Frequência (Hz)")
ylabel("Densidade espectral de potência (dB/Hz)")

% Portadora
figure(2)

subplot(2,1,1)
plot(t,ct);
title("Fig.3 - Portadora da transmissão no tempo");
xlabel("Tempo (s)")
ylabel("Amplitude (u.a)")
axis([0 1 -1.5 1.5]);

subplot(2,1,2)
plot(f, 10*log10(fftshift(abs(CT))));
title("Fig.4 - Espectro da portadora da transmissão");
xlabel("Frequência (Hz)")
ylabel("Densidade espectral de potência (dB/Hz)")

% Sinal modulado
figure(3)

subplot(2,1,1)
plot(t,y);
xlabel('tempo (s)')
ylabel('Amplitude (u.a.)')
title('Fig.5 - Sinal Modulado')
axis([0 2 -2 2]);

subplot(2,1,2)
plot(f,10*log10(abs(Ym)))
xlabel('frequência(Hz)');
ylabel('PSD (dB/Hz)');
title('Fig.6 - Espectro do sinal modulado')

% Sinal demodulado 
figure(4)

subplot(2,1,1)
plot(t,z);
xlabel('tempo (s)')
ylabel('Amplitude (u.a.)')
title('Fig.7 - Sinal demodulado')
axis([0 2 -2 2]);

subplot(2,1,2)
plot(f,10*log10(abs(Z)))
xlabel('frequência(Hz)');
ylabel('PSD (dB/Hz)');
title('Fig.8 - Espectro do sinal demodulado')

% Sinal filtrado
figure(5)
subplot(2,1,1)
plot(t,x);
hold on
plot(t,z_filt);
hold off
xlabel('tempo (s)')
ylabel('Amplitude (u.a.)')
title('Fig.9 - Sinal demodulado e filtrado')
legend('Sinal original', 'Sinal final')
axis([0 8 -2 2]);

subplot(2,1,2)
plot(f,10*log10(abs(Z_filt)))
xlabel('frequência(Hz)');
ylabel('PSD (dB/Hz)');
title('Fig.10 - Espectro do sinal demodulado e filtrado')
