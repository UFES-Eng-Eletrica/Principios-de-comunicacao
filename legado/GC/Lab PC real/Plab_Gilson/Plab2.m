%Voz -> fmax1 = 4KHz
%senoide -> fc = fmax1/2 -> 2KHz
%cossenoide-> fc = fmax1/4->1KHz

M = 256 ;%n�vel da modula��o
A = 127; %amplitude da senoide e cossenoide
ti = 0; %tempo inicial
dur = 1; %defini��o da dura��o do vetor tempo a ser constru�do
tam = 1000; %quantidade de posi��es presentes no vetor 
fmax1 = 4000;%defini��o da frequ�ncia central da voz
fc = fmax1/2;
SNR = 18;
n = tam;

t = linspace(ti, dur, tam);% uso da fun��o linspace para gerar o vetor
xa = randi([0 M-1],1,n);
xb = A*sin(2*pi*fc*t); %senoide de amplide A com frequencia fc
xc = A*cos(2*pi*(fc/2)*t); %cossenoide de amplide A com frequencia fc/2

%modula��o
x1_mod = pammod(xa, M);
x2 = floor(xb)+127;     %para o sinal 2
x2_mod = pammod(x2, 256);

x3 = floor(xc)+127;     %para o sinal 3
x3_mod = pammod(x3, 256);

%multiplexa��o
    aux = 0;        %preparando as vari�veis para a multiplexa��o
    vetor1=1;
    vetor2=1;
    vetor3=1;
  for i=1:length(x1_mod)
    if aux == 0
        sinal(i) = x1_mod(vetor1);
        vetor1=vetor1+1;
        aux = 1;
    end
    if aux ==1
        sinal(i) = x2_mod(vetor2);
        vetor2=vetor2+1;
        aux = 2;
    end
    if aux ==2
        sinal(i) = x3_mod(vetor3);
        vetor3 = vetor3+1;
        aux = 0;
    end
  end  

%transmiss�o
y_ruido = awgn(sinal, SNR, 'measured');


%demultiplexa��o
  aux = 0;        %preparando as vari�veis para a demultiplexa��o
    vetor1=1;
    vetor2=1;
    vetor3=1;
    
for i=1:length(sinal)
    if aux == 0
        y1_mod(vetor1) = y_ruido(i);
        vetor1 = vetor1+1;
        aux = 1;
    end
    if aux ==1
        y2_mod(vetor2)=y_ruido(i);
        vetor2=vetor2+1;
        aux = 2;
    end    
    if aux == 2
        y3_mod(vetor3)=y_ruido(i);
        vetor3=vetor3+1;
        aux=0;
    end
  end 

%demodula��o
y_demod = pamdemod(y2_mod, 256)-127;


%comparativo visual atrav�s de plot
plot(t, xb)
hold on
plot(t, y_demod)