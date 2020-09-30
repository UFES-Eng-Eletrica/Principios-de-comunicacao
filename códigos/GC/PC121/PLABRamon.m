clc, clear all, close all;
%
%...................... Parametros de Entrada .............................
M = 2;                                  % Nível da modulação
k = log2(M);                            % bits por símbolo
n = 3000;                               % Numero de bits da Sequencia (Bitstream)
nsamp = 4;                              % Taxa de Oversampling
Ebn0 = 0;                               %energia do bit de ruido  em dB
Esn0 = Ebn0 + 10*log10(log2(M)); 
%snr = Esn0 - 10*log10(nsamp) + 3;      % Vetor SNR em dB
snr =10;
Rb = 1e6;                               %taxa de transmissão dos bits = 1Mbps
Tb = 1/Rb;                              %periodo de amostragem
fs = 8000;

%...................... Simulação do Sistema .............................
%
disp('...................................................................')
disp('............... Modulação Digital .................................')
%

%********************** TRANSMISSÃO ***************************************
%
% ............ Geracao do sinal modulante .................................

figure();
subplot(2,3,1);
imagem1 = imread('gato.jpg');          % leitura da imagem em escla de cinza
[tam_x1,tam_y1] = size(imagem1);           % encontra o tamanho da matriz pixels
imshow(imagem1);                           % mostra a imagem original (figura 1)
vetor_im1 = reshape(imagem1.',1,[]);       % transforma em vetor
vetor_im1 = vetor_im1.';                   % transforma em vetor coluna
m1 = double(vetor_im1);                    % transforma de inteiro para double
x1 = de2bi(m1,8);                          % vetor serializado e convertido em bits
x_vec1 = reshape(x1.',1,[]);

subplot(2,3,2);


ti=0;
n=8; %numero de bits por amostras

%leitura do audio
[x,Fs]=audioread('audioprova.wav'); %audio estereo capturado
x=(x(:,1)); %capturando somente o mono

% Gerando o vetor tempo
dt= 1/Fs;                          % Periodo de amostragem                              
t = (ti:dt:(length(x)-1)*dt).';     % Gera o vetor tempo

N = 2^(n-1); %numero de pontos por amostra

quant= max(x)/(N-1); % Valor da quatizacao do sinal de voz

x_disc = ceil(x(:)/quant) ;

x_disc2 = x_disc.';% Sinal de audio discretizado

nn = 8;       % bits para representacao
NN = 2^8;     % niveis
vetor = x_disc2;

amplitude = abs(max(vetor)) + abs(min(vetor));
amp2 = amplitude;
absoluto = abs(min(vetor));   %usado para jogar todo o sinal para a parte positiva do eixo Y

%quantizando
vetor = vetor + absoluto;
vetor = vetor*((NN-1)/amplitude);
vetorquantizado = round(vetor);

%transformando em um vetor de bits
vetorbin = de2bi(vetorquantizado);
vetorbin = vetorbin';
vetorbin = vetorbin(:); %vetor pronto para ser enviado

plot(t, x_disc, t,x);


subplot(2,3,3)

t3 = 0:0.001:100;
x3 = sin(2*pi*0.011*t3);
nn = 8;       % bits para representacao
NN = 2^8;     % niveis
vetor = x3;

amplitude = abs(max(vetor)) + abs(min(vetor));
absoluto = abs(min(vetor));   %usado para jogar todo o sinal para a parte positiva do eixo Y

%quantizando
vetor = vetor + absoluto;
vetor = vetor*((NN-1)/amplitude);
vetorquantizado = round(vetor);

%transformando em um vetor de bits
vetorbin2 = de2bi(vetorquantizado);
vetorbin2 = vetorbin2';
vetorbin2 = vetorbin2(:); %vetor pronto para ser enviado

plot(t3,x3)

% Multiplexacao das tres imagens
cont = 1;

x = zeros(1,(length(x_vec1)+length(vetorbin)+length(vetorbin2)));  % x Ã© o vetor com as tres senoides


for ii = 1:length(vetorbin)
    
    if ii <= 800008
        x(cont) = x_vec1(ii);
        x(cont+1) = vetorbin(ii);
        x(cont+2) = vetorbin2(ii);
        cont = cont+3;
    elseif ii <= 947928
        x(cont) = x_vec1(ii);
        x(cont+1) = vetorbin(ii);
        cont = cont+2;
    else 
        x(cont) = vetorbin(ii);
        cont = cont+1;
    end
end

% Modulacao (PAM-2)
xmod = pammod(x,M);

% Reamostragem (upsample)
x_up = rectpulse(xmod,nsamp);

% *********************** CANAL *******************************************
% Adiciona ruido Gaussiano branco ao sinal
y_ruido = awgn(x_up,snr,'measured');

% *************************************************************************


% ********************** RECEPCAO *****************************************
% Reamostragem (downsample)
y_down = intdump(y_ruido,nsamp);

% Demodulacao (M-PAM)
y = pamdemod(y_down,M); % Demapeamento

%% Demultiplexacao das tres imagens 
cont = 1;

for ii = 1:length(vetorbin) %maior vetor
    if ii <= 800008 % menor vetor
       
    im1_final(ii) = y(cont);
    im2_final(ii) = y(cont+1);
    im3_final(ii) = y(cont+2);
    cont = cont + 3;
    
    elseif ii <= 947928 % segundo menor
            
    im1_final(ii) = y(cont);
    im2_final(ii) = y(cont+1);
    cont = cont + 2;
    
    else
    im2_final(ii) = y(cont); 
    cont = cont + 1;
    
    end
    
     
end

% ================ Mostra a imagem demodulada =============================
subplot(2,3,4);
y_bin1 = reshape(im1_final,8,[]);
y_bin1 = y_bin1.';
y_dec1 = bi2de(y_bin1);
% figure;                                       % figura 2
imag_demod1 = uint8(y_dec1);              % transforma para inteiro 
[imagem_demod1,paded] = vec2mat(imag_demod1,tam_y1); % transforma em matriz
imshow(imagem_demod1);

subplot(2,3,5);

im2_final = im2_final';
saidabin = reshape(im2_final',8,size(im2_final,1)/8);
saidabin = saidabin';

saidadec = bi2de(saidabin);
saidadec = saidadec';

saida = saidadec*(amplitude/(NN-1));
saida = saida - absoluto;
saida = saida.';
saida = saida * (amp2/2);
plot(t, saida);

subplot(2,3,6);

im3_final = im3_final';
saidabin = reshape(im3_final',8,size(im3_final,1)/8);
saidabin = saidabin';

saidadec = bi2de(saidabin);
saidadec = saidadec';

saida = saidadec*(amplitude/(NN-1));
saida = saida - absoluto;
saida = saida.';
plot(t3, saida);

 if nsamp == 1
    offset = 0;
     h =  eyediagram(real(y_down),2,1,offset);
 else
    offset = 2;
     h =  eyediagram(real(y_down),3,1,offset);
 end
 set(h,'Name','Diagram de Olho sem Offset');
% Mostra o Diagrama de Constelação
 scatterplot(y_down)