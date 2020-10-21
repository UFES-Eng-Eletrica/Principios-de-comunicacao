%LABORATÓRIO 3
%atualizado dia 27/09/2018
%Modulação de Amplitude AM
%% Modulação AM SSB/TC

%% Inicialização do script
clear all;
clc;
close all;
format short;

%% parametrização
fm= 1; %freq do sinal modulante  Fc+fm <= Fs/k (sugestão Fc 10x menor q Fs) -> teorema da amostragem
fs= 100;  %taxa de amostragem (samples/s)
ta=1/Fs;
Fc= 10*fm ;  %freq da portadora
A= 1;  %amplitude do sinal modulante
ts= 1/Fs; %
tam=1024; %tamanho do vetor
t=[0:1/Fs:(tam-1)*ts]; %vetor tempo
Eo= 0; %amplitude da portadora
x=A*cos(2*pi*fm*t); %sinal modulante
p=Eo*cos(2*pi*Fc*t); %sinal da portadora
%Ps=     %Potência do sinal
%Pr=     %Potência do ruído
snr=30; %10*log(Ps/Pr) - relação de potências

%% Processamento
y= ssbmod(x,Fc,Fs,0, 'upper');


%canal de comunicação
%r=y; % Back2Back
r= awgn(y,snr, 'measured'); %adição de ruído Gaussiano

%demodulação
rx=ssbdemod(r,Fc,Fs);

%% geração do vetor frequência
df=1/(tam*ta);
freqpositiva= 0:df:(tam/2)*df; %freqüências positivas
freqnegativa=-((tam/2)-1)*df:df:-df; %freqüências negativas
freq=[freqpositiva freqnegativa]; %

%Sinal modulado no domínio da frequência
[X,sinal_tf,f,df]= FFT_pot2(x,ta);
[Y,sinal_tf,f,df]= FFT_pot2(y,ta);
[R,sinal_tf,f,df]= FFT_pot2(r,ta);
[RX,sinal_tf,f,df]= FFT_pot2(rx,ta);



%% NA AM Ssb/sc há 2 modulações, uma na parte superior e uma na inferior 
% defesada de 90 graus





%% Plotagem
%sinal modulante
figure(1), subplot(211), plot(t,x);
xlabel('Tempo(s)');
ylabel('Amplitude(u.A)');
grid on;
title('Sinal modulante');
grid on;

figure(1), subplot(212), plot(f,fftshift(db(abs(X))));
xlabel('Freqência(Hz)');
ylabel('psd(dB/Hz)');
grid on;
title('Espectro modulante');

%sinal modulado
figure(2), subplot(211), plot(t,y, 'g');
xlabel('Tempo(s)');
ylabel('Amplitude(u.A)');
grid on;
title('Sinal modulado');
grid on;

figure(2), subplot(212), plot(f,fftshift(db(abs(Y))),'g');
xlabel('Freqência(Hz)');
ylabel('psd(dB/Hz)');
grid on;
title('Espectro modulado');

%sinal modulado com ruído
figure(3), subplot(211), plot(t,r, 'g');
xlabel('Tempo(s)');
ylabel('Amplitude(u.A)');
grid on;
title('Sinal modulado com ruído');
grid on;

figure(3), subplot(212), plot(f,fftshift(db(abs(R))),'g');
xlabel('Freqência(Hz)');
ylabel('psd(dB/Hz)');
grid on;
title('Espectro modulado com ruído');

%sinal demodulado
figure(4), subplot(211), plot(t,rx, 'r');
xlabel('Tempo(s)');
ylabel('Amplitude(u.A)');
grid on;
title('Sinal demodulado');
grid on;

figure(4), subplot(212), plot(f,fftshift(db(abs(RX))),'r');
xlabel('Freqência(Hz)');
ylabel('psd(dB/Hz)');
grid on;
title('Espectro demodulado');


