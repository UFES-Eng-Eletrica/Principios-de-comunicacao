%% ========== Sistema de modulacao digital PAM ==========
%
%
% Lab07 - Simulando um sistema de comunicao utilizando multiplexação TDM

clc; close all; clear all;
%Rb fornecido = 1 Mbps
%Modulacao PAM-2 => M=2
M = 256; % 256 simbolos, ou niveis diferentes de tensao
k = log2(M); % bits por simbolo (= 8 bits por simbolo)
snr = 20; %Definindo a proporcao de potencia sinal/ruido
Rb_ch = 1e6; % Taxa de na saida do modulador = 1 Mbps
Rb = (Rb_ch)/3; % Taxa de bits dos sinais individuais = 1/3 Mbps
Ts = k/Rb; % Periodo de amostragem (Quanto tempo demora para transmitir um simbolo de 8 bits)
n = 3e4; % Numero de bits transmitidos por sinal individual (30000 bits para cada sinal)
n_ch = 3*n; %Numero de bits transmitidos no canal (90000 bits juntando os e sinais)
tf = n/Rb; %Duracao do sinal
%Frequencia das senoides
f1 = 2*6*pi;
f2 = 2*f1;
f3 = 3*f1; %Ts deve ser menor que 1/2*f3 ou 44 e-04 s (verificado)
%Gerando um vetor tempo para as senoides
t = 0:Ts:(tf-Ts);
%Gerando 3 senoides de amplitudes diferentes
s1 = 3*sin(f1*t);
s2 = 6*sin(f2*t);
s3 = 12*sin(f3*t);

%Fazer uma multiplexação TDM para as 3 senoides e depois modular em PAM, reconstruir as 3 senoides
%Periodo de amostragem do canal eh calculado pela relacao:
Ts_ch = Ts/((Rb_ch)/Rb); %Periodo de amostragem do canal
%Criamos um multiplexador;
%Alocando o vetor de dados da saida do multiplexador
s_ch = zeros(1,(3*length(s1))); %A quantidade de dados que saem do multiplexador eh 3 vezes a quantidade de dados
                                %que sai de cada sinal
%Alocando um contador
i = 1;
 for k=1:(length(t))
     s_ch(i) = s1(k);   %A posicao 1*n pega um simbolo do primeiro sinal
     i = i + 1;
     s_ch(i) = s2(k);   %A posicao 2*n pega um simbolo do segundo sinal
     i = i + 1;   
     s_ch(i) = s3(k);   %A posicao 3*n pega um simbolo do terceiro sinal
     i = i + 1;
 end
%Digitalizamos os sinais multiplexados
%Fazemos um offset com a maior amplitude para tornar os sinais positivos
offset = ceil(max(s_ch));
s_ch(:) = s_ch(:) + offset;
%Multiplicamos as amplitudes para aumentar a precisao
s_ch(:) = 10*s_ch(:);
%Convertemos de double para inteiro de 8 bits
s_ch = uint8(s_ch); 
%Convertemos de inteiro para binario 8-bit
i = 1;
temp = zeros(1,8);
d_ch = zeros(1,8*length(s_ch));
for k=1:length(s_ch);
    [s_ch padded] = vec2mat(s_ch,1); % Transformando o vetor de uma linha em um vetor de 1 coluna
    temp = de2bi(s_ch(k),8); %Converte o elemento na linha k em binario de 8 bits
    d_ch(i) = temp(1);
    d_ch(i+1) = temp(2);
    d_ch(i+2) = temp(3);
    d_ch(i+3) = temp(4);
    d_ch(i+4) = temp(5);
    d_ch(i+5) = temp(6);
    d_ch(i+6) = temp(7);
    d_ch(i+7) = temp(8);
    i = i + 8;
end
%-------------------TRANSMISSAO-------------------------------
M = 2; %Utilizando a modulacao PAM-2, temos 2 simbolos
k = log2(M); %Calculando o numero de bits por simbolo
data = pammod(d_ch,M); %Realizando a modulacao PAM
%Plotando o diagrama de constelacao
scatterplot(data); %Constelacao na saida da modulacao PAM
title('Constelação na entrada do canal');
%Realizando o upsampling
nsamp = 4;
data_up = rectpulse(data,nsamp);
%------------------CANAL--------------------------------------
%No canal, inserimos o ruido gaussiano branco
data_ch = awgn(data_up,snr,'measured');

%-------------------RECEPCAO---------------------------------
%Na recepcao, fazemos o downsampling
data_down = intdump(data_ch,nsamp);
%Plotando o diagrama de constelacao
scatterplot(data_down); %Constelacao na saida do intdump
title('Constelação na saida do canal');
%Realizando a demodulacao
data_rec = pamdemod(data_down,M); %dados recuperados depois da demodulação
%Comparando os dados binarios para identificar os erros
%******************* Calcula os erros *************************************
d_bit = (abs(d_ch-data_rec)); %Como os dados est�o em binario, geramos um vetor em que cada '1' � um bit diferente nos vetores x e y
n_erros = sum(d_bit); %O numero de bits transmitidos errado � igual � soma desses '1' no vetor diferen�a
ber_awgn = mean(d_bit);%Bit Error Rate = média de erros

%************** Mostra Resultad os Provis�rios na Tela *********************
% %
disp(sprintf('SNR: %4.1f dB',snr)); %mostra a rela��o sinal/ruido em db
disp(sprintf('BER: %5.1e ',ber_awgn)); %mostra a taxa de erro de bits (bit error rate)
disp(sprintf('Qtd de erros: %3d',n_erros)); %mostra o numero de bits que foram transmitidos errado
% %
disp('...................................................................')
% %
% %

%___________________________DEMUX_____________________________
%Primeiramente convertemos os dados em binario para inteiros 8-bit
s_ch_rec = zeros(1,length(s_ch)); %Alocando o vetor de sinais inteiros
[mat, padded] = vec2mat(data_rec,8); %Transformando o vetor de uma linha em uma matriz com 8 colunas (8 bits = 1 inteiro)
for p=1:length(s_ch_rec)
    temp = mat(p,:);
    temp = bi2de(temp);
    s_ch_rec(1,p) = temp;
end
s_ch_rec = (s_ch_rec)';
%Desfazemos o escalonamento
s_ch_rec(:) = s_ch_rec(:)/10;
%Desfazemos o offset
offset = (ceil(max(s_ch_rec)))/2;
s_ch_rec(:) = s_ch_rec(:) - offset;
%Alocamos espaco para os vetores de sinais recebidos
s1_rec = zeros(1,(length(s_ch_rec)/3));
s2_rec = zeros(1,(length(s_ch_rec)/3));
s3_rec = zeros(1,(length(s_ch_rec)/3));
%Resetamos o contador 
i = 1;
%Agora, realizamos a demultiplexacao
 for k=1:(length(s3_rec))
     s1_rec(k) = s_ch_rec(i);
     i = i + 1;
     s2_rec(k) = s_ch_rec(i);
     i = i + 1;
     s3_rec(k) = s_ch_rec(i);
     i = i + 1;
 end
%Plotamos os graficos dos sinais 
figure
subplot(1,2,1);
plot(t,s1);
title('Sinal 1');
subplot(1,2,2);
plot(t,s1_rec);
title('Sinal 1 recuperado');
figure
subplot(1,2,1);
plot(t,s2);
title('Sinal 2');
subplot(1,2,2);
plot(t,s2_rec);
title('Sinal 2 recuperado');
figure
subplot(1,2,1);
plot(t,s3);
title('Sinal 3');
subplot(1,2,2);
plot(t,s3_rec);
title('Sinal 3 recuperado');


