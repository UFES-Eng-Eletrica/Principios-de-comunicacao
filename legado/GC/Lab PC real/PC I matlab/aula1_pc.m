%inicialização
clear all;
clc;

%% parametriza��o
to=0; %tempo inicial
tf=1e-6; %tempo final
tam=1024; %tamanho do vetor
A=1;%amplitude unit�ria
k0 = 10; %fator de amostragem
 
%% processamento/gera��o do vetor tempo
t=linspace(to,tf,tam);% ou t=to:tf/tam:tf (� isso mesmo?)

%% taxa de amostragem e per�odo de amostragem
ta=t(2)-t(1);
fs=1/ta; %taxa de amostragem

%% gera��o da sen�ide, encontrando fc e plotando o sinal gerado
fc0=fs/k0; %fc, sendo fa >= k*fmax
%fc varia de acordo com k. Para variarmos fc,basta que variemos k, que � o
%fator de amostragem
x0=A*sin(2*pi*fc0*t); % cria��o da fun��o sen�ide desejada

%% gera��o do vetor freq��ncia
df=1/(tam*ta);
freqpositiva= 0:df:(tam/2)*df; %freqüências positivas
freqnegativa=-((tam/2)-1)*df:df:-df; %freqüências negativas
freq=[freqpositiva freqnegativa]; %
figure;
plot(freq);

%% Geração dos sinais senoidais
%já temos fc0; famostragem/fsamples
figure;

subplot(3,2,1);%plotagem de todas as diferentes x para diferentes fc para diferentes k
plot(t,x0);;

%% espectro para a senoide
[Sinal_ff,sinal_tf,f,df] = FFT_pot2(x0,ta);
figure;
plot(f,fftshift(db(abs(Sinal_ff))));

%% para casa: encontrar a sinc do espectro para pulso quadrado
%mexer nessa parte do código e pergunta ao jorge henrique
xquadrada = zeros(size(t));
xquadrada((end/2)-(end/8):(end/2)+(end/8))=ones(size(xquadrada((end/2)- (end/8):(end/2)+(end/8))));
[Sinal_ff,sinal_tf,f,df] = FFT_pot2(xquadrada,ta);
figure;
plot(f, fftshift(db(abs(Sinal_ff)))); %plotagem do fftshift da onda quadrada
%plot(freq,(abs(X)));
grid;
ylabel('psd : densidade espectral de potencia (dB/Hz)');
xlabel(' frequencia'); 

%% calculo das potencias medias

%potencia da senoide
%potdbm(x0); %em w
[pmn,pmndbm] = potdbm(x0); %em dBm
%potencia da onda quadrada
[pmnquadrada, pmndbmquadrada] = potdbm(xquadrada);

%% filtro passa baixa de 3e-7
Wn=2.5e7/(fs/2); %frequencia de corte do filtro em porcentagem referida no quadro
[b,a]= butter(5,Wn,'low'); %criacao do filtro 
y=filter(b,a,xquadrada); %convolucao interna entre o sinal e o filtro, executando
% o filtro criado pelo butter no sinal xquadradada
figure;
plot(t,y); %plot do sinal filtrado no domínio do tempo
[Sinal_ff,sinal_tf,f,df] = FFT_pot2(y,ta);
figure;
%plot do do fft do sinal filtrado
plot(f, fftshift(db(abs(Sinal_ff)))); %geracao da onda filtrada no dominio da frequencia
% tanto faz f ou freq


%% ondulação do sinal
%banda base= espectro centrado em 0
%banda passante = ja modulado para fp, centrado em outra frequencia
fport=500000; % a frequencia modulante, que eh da grandeza de 10e8, deve ser muito inferior à 
%frequencia da portadora
port=A*cos(2*pi*fport*t); %criando a portadora
modul = conv(y,port);
figure;
plot(t, y);
hold on;
t=linspace(0,t(end)*2,length(y));
plot( t , modul(1024:end));
hold off;
