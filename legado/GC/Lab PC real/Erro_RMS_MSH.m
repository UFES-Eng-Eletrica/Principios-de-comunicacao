%Relação Erro RMS com SNR

%% parametrização
fm= 1; %freq do sinal modulante  Fc+fm <= Fs/k (sugestão Fc 10x menor q Fs) -> teorema da amostragem
Fs= 100;  %taxa de amostragem (samples/s)
ta=1/Fs;
Fc= 10*fm ;  %freq da portadora
A= 1;  %amplitude do sinal modulante
ts= 1/Fs; %
tam=1024; %tamanho do vetor
t=[0:1/Fs:(tam-1)*ts]; %vetor tempo
Eo= 2; %amplitude da portadora
x=A*cos(2*pi*fm*t); %sinal modulante
p=Eo*cos(2*pi*Fc*t); %sinal da portadora
%Ps=     %Potência do sinal
%Pr=     %Potência do ruído
SNR=0:5:50; %Vetor SNR para plotagem
cont=1;
Erro_RMS=0:5:50;

%% Processamento
y= ammod(x,Fc,Fs,0, Eo);

for cont=1:length(SNR)
r= awgn(y,SNR(cont), 'measured'); %adição de ruído Gaussiano

%demodulação
rx=amdemod(r,Fc,Fs);
Erro_RMS(cont)=rms(x-rx);

plot(SNR,Erro_RMS);
end