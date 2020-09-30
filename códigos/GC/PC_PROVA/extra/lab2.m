% Lab 2 - Principios Comunica??es I
% 
% by Prof. Jair Silva
% 
% =========================================================================

% Inicializa??o
clc, clear all, close all

%% --------- Primeira parte - Sinal de Pot?ncia e Sinal de Energia --------
% Parametros de entrada
dt = 0.002;      % Intervalo de amostragem
T  = 6;          % Periodo da fun??o geradora
M  = 3;          % Qtd de periodos do sinal 

% Gera o vetor tempo, o sinal e plota o sinal
t = [0:dt:T-dt];
y = exp(-abs(t)/2).*sin(2*pi*t).*(udeg(t)-udeg(t-4));
figure, plot(t,y);

% Gera e plota a fun??o periodica
tt = [];
yp = [];
for k = 1:M
    tt = [tt (k-1)*T+t];
    yp = [yp y];
end
figure, plot(tt,yp);

% Calcula a pot?ncia e a energia da fun??o peri?dica
pmed = (sum(yp*yp')*dt)/(max(tt)-min(tt))
energ = sum(y.*conj(y))*dt

%% ------------- Segunda parte - Teorema da Convolu??o  -------------------
% Parametros de entrada
dt = 0.01;       % novo intervalo de amostragem
T  =  6;         % mesmo periodo
t  = [-1:dt:T];  % novo vetor tempo

% Gera as fun??es geradoras pedidas no roteiro 
x  = udeg(t) - udeg(t-5);
g1 = 0.5*x;
g2 = -x;
g3 = exp(-t/5).*x;
g4 = exp(-t).*x;
g5 = sin(2*pi*t).*x;

% Plota as fun??es geradoras
figure, 
subplot(2,3,1), plot(t,x); axis([-1 6 -1.5 1.5])   
subplot(2,3,2), plot(t,g1); axis([-1 6 -1.5 1.5])   
subplot(2,3,3), plot(t,g2); axis([-1 6 -1.5 1.5])   
subplot(2,3,4), plot(t,g3); axis([-1 6 -1.5 1.5])   
subplot(2,3,5), plot(t,g4); axis([-1 6 -1.5 1.5])   
subplot(2,3,6), plot(t,g5); axis([-1 6 -1.5 1.5])   

% Executa as convolu??es 
x_g1 = conv(x,g1); 
x_g1 = x_g1./max(x_g1);
t_conv = linspace(0,2*T,length(x_g1));

x_g2 = conv(x,g2); 
x_g2 = x_g2./max(x_g2);

x_g3 = conv(x,g3); 
x_g3 = x_g3./max(x_g3);

x_g4 = conv(x,g4); 
x_g4 = x_g4./max(x_g4);

x_g5 = conv(x,g5); 
x_g5 = x_g5./max(x_g5);

% Plota as convolu??es
figure
subplot(2,3,1), plot(t_conv,x_g1); 
axis([min(t_conv) max(t_conv) min(x_g1) max(x_g1)+ 0.2])   

subplot(2,3,2), plot(t_conv,x_g2); 
% axis([min(t_conv) max(t_conv) min(x_g2) max(x_g2)+ 0.2]) 

subplot(2,3,3), plot(t_conv,x_g3); 
axis([min(t_conv) max(t_conv) min(x_g3) max(x_g3)+ 0.2]) 

subplot(2,3,4), plot(t_conv,x_g4); 
axis([min(t_conv) max(t_conv) min(x_g4) max(x_g4)+ 0.2])  

subplot(2,3,5), plot(t_conv,x_g5); 
axis([min(t_conv) max(t_conv) min(x_g5) max(x_g5)+ 0.2])  

% --------------- Terceira Parte - Teorema da Modula??o -------------------
% Parametros de entrada
dt = 0.002;      % Intervalo de amostragem
T  = 6;          % Periodo da fun??o geradora
M  = 3;          % Qtd de periodos do sinal 

% Gera o vetor tempo
t  = [0:dt:T-dt];
ta = t(2) - t(1); 
x1 = zeros(size(t));

% Gera e plota os sinais - pulso quadrado e pulso quadrado modulado
x1((end/2)-(end/8):(end/2)+(end/8))= ones(size(x1((end/2)- (end/8):(end/2)+(end/8))));
x2 = x1.*sin(2*pi*60*t);
figure, plot(t,x1), hold all, plot(t,x2,'--');

% Calcula e plota os espectros dos sinais - pulso quadrado e pulso quadrado modulado 
[X1,xn1,f,df] = FFT_pot2(x1,dt);
[X2,xn2,f,df] = FFT_pot2(x2,dt);
figure, plot(f,10*log10(fftshift(abs(X1)))), hold all
plot(f,10*log10(fftshift(abs(X2)))), grid

% 
% 