% Atividade feita por Arthur Lorencini Bergamaschi
clc,clear
%%
% 1 - Gere  um  vetor  tempo  com  duração  de  1μs  e  1000  posições  e
% determine  o  período  de amostragem nesta situação.

% Conforme visto na introdução ao matlab:
% a = linspace(0,100,11) [start=0,stop=100], n of terms=11.

duration = 10^-6;
divisions = 1000;
time = linspace(0,duration,divisions); % ('divisions' posições espaçadas de 'duration')
timeInterval = time(2) - time(1); % Intervalo de tempo entre as amostras.

%%
% 2 - A partir do vetor tempo, crie um vetor frequência apto para analisar
% o conteúdo espectral de sinais periódicosatravés da série exponencial
% de Fourier.

frequency = 1/timeInterval; % calculando a frequência fundamental.
% Trivial, certo?

% Lembrando que dá para criar um vetor linha ao fazer
% j:k -> [j, j+1,...,k]
% j:i:k -> [j, j+i,...,k]

% Ok, mas oq q é q ele tá pedindo? WTF seria um vetor apto para isso?
% Eu acredito que seja um vetor de mesma extensão do time, mas na freq...
% Sendo metade positiva, metade negativa. Espectro simétrico, segundo
% o CAP3 - Módulo 1. Imagino que as frequências são "discretas"
% Essas frequências são as harmônicas. nf_0.
% Posso estar errado...
% Vamos lá.

positiveFreq = 0:frequency:(divisions/2)*frequency;
% as frequências positivas são um conjunto de pontos igualmente espaçados
% contendo as harmonicas, ou seja, multiplos naturais da frequência natural
% Esse vetor tem tamanho 501 (divisions/2 + 1) (pois contém o zero)

negativeFreq = -(divisions/2 - 1)*frequency:frequency:-frequency;
% as frequências negativas são espalhadas no eixo vertical.
% Contém as harmonicas, ou seja, -n*frequência.
% Esse vetor começa numa distancia 'negativa' da metade do tempo - 1 (para
% podermos desconsiderar o zero q está na positiva).
% Esse vetor é espaçado de n frequências naturais, que nem o outro.
% E ele termina em - freq (que seria a frequencia_-1)
% Ele possui tamanho 499 (divisions/2 - 1) (pois não contem o zero)
f = [positiveFreq negativeFreq];


%%
% 3 - Escolha uma frequência fcem Hz e crie um sinal senoidal x(t)com
% frequência de oscilação fce “plote” um gráfico que ilustre o sinal
% de mensagem criado.

oscFreq = frequency/100; % (em [Hz])

signalX = sin(2*pi*time*oscFreq); 
% ele vai conter o mesmo tamanho do vetor time
% e tem que estar em radianos né galera.
figure(1)
plot(time,signalX)


%%
% 4 - Varie  o  valor  de fce  analise  o  efeito  da  amostragem  do
% sinal.
% Que  conclusão  consegues encontrar durante esta tarefa? 

oscFreq = frequency/10; % (em [Hz])

signalX = sin(2*pi*time*oscFreq);
% ele vai conter o mesmo tamanho do vetor time
figure(2)
plot(time,signalX)

% Sei lá, to com sono.

%%
% 5 - Encontre a potência em dBm do sinal de mensagem gerado.
% WTF é sinal de mensagem? Vambora... Lembrando que:
% dBm (pot) = 10log_10(Pot/1000mW)
% Pra fazer a potência eu preciso meter um somatório, eu acho...

x1 = sin(2*pi*time);
x2 = sin(2*pi*2*time);
sinal = x1 + x2;

[X,x_tf,f,df] = FFT_pot2(sinal,timeInterval);
fftAbs = fftshift(abs(X));
pot = 10*log10(fftAbs);
figure(3)
plot(f,pot)
%%

ac = 1;
fc = 10*frequency;
ct = ac*cos(2*pi*fc*time);
[CT,ct_tf,f,df] = FFT_pot2(ct,timeInterval);

fftAbs = fftshift(abs(CT));
pot = 10*log10(fftAbs);
figure(4)
plot(fc,pot)


