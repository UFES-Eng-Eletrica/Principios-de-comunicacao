%LABORATÓRIO 2
%atualizado dia 20/09/2018
%Convolução e Teorema da Modulação

%% Inicialização do script
clear all;
clc;
close all;
format short;

%% parametrização
ti=0; %tempo inicial
tf=6; %tempo final
ta=0.002;
p=3;

%% Processamento
t=ti:ta:tf-ta; %geração do vetor tempo
y = exp(-abs(t)/2).*sin(2*pi*t).*(udeg(t)-udeg(t-4)); %%Sinal de energia
figure, plot(t,y);

% Gera e plota a função periodica
tt = [];
yp = [];
for k = 1:p
    tt = [tt (k-1)*tf+t];
    yp = [yp y];
end
figure, plot(tt,yp);

%Análise do teorema da modulação
dt = 0.002;      % Intervalo de amostragem
T  = 6;          % Periodo da fun��o geradora
M  = 3;  

ta = t(2) - t(1); 
x1 = zeros(size(t));

% Gera e plota os sinais - pulso quadrado e pulso quadrado modulado
x1((end/2)-(end/8):(end/2)+(end/8))= ones(size(x1((end/2)- (end/8):(end/2)+(end/8))));
x2 = x1.*sin(2*pi*60*t); %sinal da portadora
x3=x2.*sin(2*pi*60*t);
figure, plot(t,x1), hold all, plot(t,x2);
    
% Calcula e plota os espectros dos sinais - pulso quadrado e pulso quadrado modulado 
[X1,xn1,f,df] = FFT_pot2(x1,dt);
[X2,xn2,f,df] = FFT_pot2(x2,dt);
[X3,xn3,f,df] = FFT_pot2(x3,dt);

figure, plot(f,10*log10(fftshift(abs(X1)))), hold all
figure, plot(f,10*log10(fftshift(abs(X2)))), hold all
plot(f,10*log10(fftshift(abs(X3)))), grid

