%Primeiro Labotório de PC I
%exemplo do slide 23
%Declarando o vetor de 100 intervalos de tempo de 0,4 microssegundos
clear all; %limpa todas as variáveis
clc; %limpa o prompt

%parametrização
ti=0; %instante inicial
tf=0.4e-6; %tamanho final
tam=100;% tamanho do vetor;
A=1; %amplitude do sinal
k=10; %fator de amostragem, 2  é a taxa de nyquist e nela sempre haverá 
%erros de quantização

%processamento
t=linspace(ti,tf,tam); %vetor tempo em função dos parâmetros/variáveis


%determinação do período da amostragem e da taxa de amostragem
ta=t(2)-t(1); %1/período de amostragem = taxa de amostragem
fa=1/ta;%ta=período de amostragem e fa=taxa de amostragem

%geração do sinal de uma senóide que utilizará o vetor tempo  e plotagem
%fa >= k x* fmáxima do sinal
fc=fa/k;
x=A*cos(2*pi*fc*t); %senoide amostrada
figure; %gerar uma nova figura 
%plot(t, x); %plotagem da senoide 'x' em função de 't' 

%geração de um vetor freqüência
df=1/ta;
freqpositiva= 0:df:(tam/2)*df; %freqüências positivas
freqnegativa=-((tam/2)-1)*df:df:-df; %freqüências negativas
freq=[freqpositiva freqnegativa]; %
plot(freq);

%determinando o conteúdo spectral do sinal
X=fft(x); %transformada de fourier do sinal
figure;
plot(freq, fftshift(db(abs(X)))); 
hold on;
plot(freq, db(abs(X))); 
hold off;