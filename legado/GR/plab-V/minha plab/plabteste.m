
%%PROVA DE LABORATORIO DE PC1 DO VITOR MONTENEGRO 
%% ...................... Parametros de Entrada .............................
M = 4; % N�vel da modula��o
k = log2(M); % bits por s�mbolo = log2(M)=1
n = 30000; % Numero de bits da Sequencia (Bitstream)
nsamp = 4; % Taxa de Oversampling
snr = 7.88; % Vetor SNR em dB
tp = 0; % 0-PAM, 1-PSK, 2-QAM

%% audio e voz
[audio,Fs] = audioread('audio48kHz.wav'); % Carrega o audio padrao.
audio = audio(1:n)';
[voz,Fs2] = audioread('Voz.wav'); % Carrega voz padrao.
voz = voz(1:n)';
% Codificando voz
q_voz = max(abs(voz))/(2^7 - 1); % Quanta de voz.
voz_q = round(voz/q_voz); % Voz quantizada.
bit_sinal_voz = uint8((sign(voz)+1)/2); % 0 eh negativo, 1 eh positivo.
voz_cod = [bit_sinal_voz' de2bi(abs(voz_q'),7)];
voz_cod = reshape(voz_cod',1,[]);

% Codificando audio
q_audio = max(abs(audio))/(2^7 - 1); % Quanta de voz.
audio_q = round(audio/q_audio); % Voz quantizada.
bit_sinal_audio = uint8((sign(audio)+1)/2); % 0 eh negativo, 1 eh positivo.
audio_cod = [bit_sinal_audio' de2bi(abs(audio_q'),7)];
audio_cod = reshape(audio_cod',1,[]);
audio = audio_cod;

%%  Entrada do sistema imagem
img_rgb = imread('foto3x4.jpg');    % Importa a imagem em RGB

% ============== Manipulacao da imagem para escala de cinza ===============

% Transformando a imagem em uma sequencia de bits
img_GS = rgb2gray(img_rgb); % Representa a imagem em escala de cinza
imginicial = img_GS;
% Transforma a matriz da imagem (img_GS) de decimal para uma matriz em
% binario, onde cada linha representa um byte, pegando coluna por coluna de
% img_GS e colocando uma em baixo da outra
img_binMatrix = dec2bin((reshape(uint8(img_GS),[],1)).')-'0'; % colocar o -'0' coloca cada bit do byte em uma coluna


% Transforma a matriz de bits em um vetor de bits, colocando os bits de cada
% linha em sequencia
img_bin = reshape(img_binMatrix.',1,[]);

%% entrada do terceiro sinal , que � senoidal ou cossenoidal
ta  = 1/Fs;            % Periodo de amostragem dos sinais em banda base
tam = 2048;            % Tamanho dos vetores 
t  = (0:ta:tam*ta).';  % Cria o novo vetor tempo j? em banda passante

% --------- Primeira parte - Gera os sinais a serem multiplexados --------
% Sinal em Banda Base (Fonte I)
%fc1 = 1000;             % Frequencia central do primeiro sinal (Banda Base)
%s1  = sin(2*pi*fc1*t);  % primeiro sinal a ser multiplexado 


%% Definição dos parametros do sistema
ti = 0;             %tempo inicial
tf = 1e-6;          %tempo final
amostras = 1000;    %quantidade de posi��es no vetor
fat_amost = 10;     %fator de amostragem ( tem que ser > 2 )
A1 = 1;              %amplitude da senoide
A2 = 2;
A3 = 3;

nbits = 8;          %transforma inteiro em 8 bits
M = 2; % Nível da modulação
k = log2(M); % bits por símbolo
nsamp = 4; % Taxa de Oversampling
Ebn0 = 20;          %energia do bit de ruido  em dB
Esn0 = Ebn0 + 10*log10(log2(M)); 
snr = Esn0 - 10*log10(nsamp) + 3;       % Vetor SNR em dB
Rb = 1e6;   %taxa de transmissão dos bits = 1Mbps
Tb = 1/Rb;  %periodo de transmisão
%% Criação do vetor tempo
ta = nbits*Tb;              %nbits é a quantidade de bits usados em de2bi
t = 0:ta:999*ta;
fa = 1/ta;
fmax = fa/fat_amost;        %frequencia maxima de amostragem
f1 = fmax/3;
f2 = fmax/2;
f3 = fmax;
%% Cria��o das senoides
s1 = A1*cos(2*pi*f1*t);           %vetor da senoide 1
%s2 = A2*sin(2*pi*f2*t);         %vetor da senoide 2
%s3 = A3*sin(2*pi*f3*t);         %vetor da senoide 3
%% Convers��o de cada senoide para decimal
quant1 = max(s1)/(2^7-1);            %quantizacao da senoide 1
y1 = round(s1/quant1);
signe1 = uint8((sign(s1)'+1)/2);      %bit do sinal
out1 = [signe1 de2bi(abs(y1),7)];
out1 = reshape(out1.',1,[]);        %senoide 1 serializada e convertida
s1=round(out1*(M-1));
%% outra multiplexa��o


%% multiplexacao dos sinais
cont = 1;
x = zeros(1,3*length(img_bin));              % x é o vetor com as tres senoides
for ii = 1:length(img_bin)
    x(cont) = img_bin(ii);
    if(ii <= length(audio))
        x(cont+1) = audio(ii);
    else 
        x(cont+1) = 0;
    end
    if(ii <= length(s1))
        x(cont+2) = s1(ii);
    else 
        x(cont+2) = 0;
    end
    cont = cont+3;
end

%%  Modula��o
tp=1;
M=4;
if tp == 0
 % Modula��o (M-PAM)
 xmod = pammod(x,M); % mapeamento M - PAM
else if tp == 1
 % Modula��o (M-PSK)
 xmod = pskmod(x,M); % mapeamento
 else
 % Modula��o (M-QAM)
 xmod = qammod(x,M); % mapeamento
 end
end 

%% Reamostragem (upsample)
x_up = rectpulse(xmod,nsamp); 
%x_up=xmod;% sem rectpulse

%%  *********************** CANAL *******************************************
% Adiciona ru�do Gaussiano branco ao sinal
y_ruido = awgn(x_up,snr,'measured');

%% Reamostragem (downsample)
y_down = intdump(y_ruido,nsamp);

%% Demodula��o de y
if tp == 0
 % Demodula��o (M-PAM)
 y = pamdemod(y_down,M); % Demapeamento
 else if tp == 1
 % Demodula��o (M-PSK)
 y = pskdemod(y_down,M); % Demapeamento
 else
 % Demodula��o (M-QAM)
 y = qamdemod(y_down,M); % Demapeamento
     end
end


%% Demultiplexacao dos sinais
cont = 1;
for ii = 1: length(img_bin)
    img_final(ii) = y(cont);
    audio_final(ii) = y(cont+1);
    senoide_final(ii) = y(cont+2);
    cont = cont + 3;
end


%%  IMAGEM FINAL DEPOIS DA DEMODULACAO E SELE��O
resol=8; %resolucao da amostra em bits
y_binMatrix = (reshape(img_final,resol,[])).';
% Transforma os valores de binario para decimal
y_binCol = bin2dec(char(y_binMatrix+'0'));
% Reorganiza o vetor com valores em decimal para uma matriz que representa
% a imagem original
[a,b] = size(img_GS); % Utilizado para informar as dimensoes da imagem
y_GS=reshape(uint8(y_binCol),a,b); % Matriz que representa a imagem recebida em escala de cinza
%% *********** Calcula os erros *************************************
%d_bit = (abs(x-y));
%n_erros = sum(d_bit);
%ber = mean(d_bit);
figure;
imshow(y_GS);
figure;
imshow(imginicial);

%% decodificacao do audio
y_audio=audio_final;
%y_voz = reshape(y_voz,8,[]);
y_audio = reshape(y_audio,8,[]);
%y_voz = bi2de(y_voz');
y_audio = bi2de(y_audio');

%bit_sinal_voz = changem(double(bit_sinal_voz),-1,0); % Ajuste de sinal.
%y_voz = bit_sinal_voz'.*y_voz; % Aplicando sinal.

bit_sinal_audio = changem(double(bit_sinal_audio),-1,0);
y_audio = bit_sinal_audio'.*y_audio;

%% Desquantizacao

y_voz = y_voz*q_voz/2;
y_audio = y_audio*q_audio/2;
% Plotar o audio original
figure(1)
plot(t,audio);
title('Sinal de Voz Original');

% Plotar o audio decodificado
figure(2)
plot(t,audiofinal);
title('Sinal de Voz com Ruido');

[Sinal_ff,sinal_tf,f,df] = FFT_pot2(audio.',dt); %Gera a FFT

%Plote no dominio da frequencia
figure(3)
plot(f,10*log10(fftshift(abs(Sinal_ff))));

xlabel('Frequencia [Hz]');
ylabel('Amplitude [dB]');
title('Sinal de Voz Original');
%sound(m2,Fs);% Sinal Original
%pause(10);
%sound(m2,Fs);
% Mostra o diagram de olho na saída do canal
%if nsamp == 1
 %   offset = 0;
  %  h =  eyediagram(real(y_down),2,1,offset);
%else
 %   offset = 2;
  %  h =  eyediagram(real(y_down),3,1,offset);
%end

%set(h,'Name','Diagram de Olho sem Offset');


% Mostra o Diagrama de Constelação
scatterplot(y_down)
