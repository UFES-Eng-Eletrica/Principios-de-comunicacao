%% PCI - PLAB

close all;
clear all;
clc;

% --------------------- PARAMETROS ------------------------------

M_im    = 2;       % Nivel da modulacao para a imagem
M_cos   = 2;        % Nivel da modulacao para o cosseno
M_sen   = 2;       % Nivel da modulacao para a seno

K_im    = log2(M_im);       % Bits por simbolo da imagem
K_cos   = log2(M_cos);     % Bits por simbolo do cosseno
K_sen   = log2(M_sen);      % Bits por simbolo da seno

snr = 50;
nsamp = 4;

% ------------------- TRANSMISSAO ----------------

% Gerando bitstream da imagem
[IBIN,x,y] = ler_imagem('fotogcmf.jpg');       % Le a imagem
SalvaImagem = imread('fotogcmf.jpg');          % Armazena a imagem original
SalvaImagem = SalvaImagem(:,:,1);             % Pega so a 1 imagem

% % Gerando bitstream do audio
% [AUDIO,amp,abso,Fs] = ler_audio('audioprova.wav',8);% Le o audio
% [SalvaAudio,~] = audioread('audioprova.wav');       % Armazena o audio original
% dt = 1/Fs;                                      % Periodo de amostragem
% t1 = (0:dt:(length(SalvaAudio)-1)*dt).';        % Gera o vetor tempo

% Modulacao da imagem
IBINPARALELO = vec2mat(IBIN,K_im);  % BITS POR SIMBOLO
I_SIMBOLOS = bi2de(IBINPARALELO)';
IMOD = pskmod(I_SIMBOLOS,M_im);
IMOD_UP = rectpulse(IMOD,nsamp);

% % Modulacao do audio
% AUDIOBINPARALELO = vec2mat(AUDIO,K_audio);
% AUDIO_SIMBOLOS = bi2de(AUDIOBINPARALELO)';
% AUDIOMOD = oqpskmod(AUDIO_SIMBOLOS,M_audio);
% AUDIOMOD_UP = rectpulse(AUDIOMOD,nsamp);

% Modulacao da seno
tf = 1;
A_sen = 1;
f_sen = 30;
Fs_sen = 300;
Ts_sen = 1/Fs_sen;
t_sen = 0:Ts_sen:tf-Ts_sen;
SENOIDE = A_sen*sin(2*pi*f_sen.*t_sen);

n = 8;       % bits para representacao
N = 2^n;     % niveis

vetor = SENOIDE;

amplitude = abs(max(vetor)) + abs(min(vetor));
absoluto = abs(min(vetor));   % Sinal na parte positiva de Y

% Quantizando
vetor = vetor + absoluto;
vetor = vetor*((N-1)/amplitude);
vetorquantizado = round(vetor);

% Transformando em um vetor de bits
vetorbin = de2bi(vetorquantizado);
vetorbin = vetorbin';
vetorbin = vetorbin(:);         % Vetor pronto para ser enviado
SENOIDEBIN  = vetorbin;

SENOIDEBINPARALELO = vec2mat(SENOIDEBIN,K_sen);
SENOIDE_SIMBOLOS = bi2de(SENOIDEBINPARALELO)';
SENOIDEMOD = pskmod(SENOIDE_SIMBOLOS,M_sen);
SENOIDEMOD_UP = rectpulse(SENOIDEMOD,nsamp);

% Modulacao da cosseno
tf = 1;
A_cos = 1;
f_cos = 30;
Fs_cos = 300;
Ts_cos = 1/Fs_cos;
t_cos = 0:Ts_cos:tf-Ts_cos;
SENOIDE2 = A_cos*cos(2*pi*f_cos.*t_cos);

ncos = 8;       % bits para representacao
Ncos = 2^ncos;     % niveis

vetorcos = SENOIDE2;

amplitudecos = abs(max(vetorcos)) + abs(min(vetorcos));
absolutocos = abs(min(vetorcos));   % Sinal na parte positiva de Y

% Quantizando
vetorcos = vetorcos + absolutocos;
vetorcos = vetorcos*((N-1)/amplitudecos);
vetorquantizado2 = round(vetorcos);

% Transformando em um vetor de bits
vetorbin2 = de2bi(vetorquantizado2);
vetorbin2 = vetorbin2';
vetorbin2 = vetorbin2(:);         % Vetor pronto para ser enviado
SENOIDEBIN2  = vetorbin2;

SENOIDEBINPARALELO2 = vec2mat(SENOIDEBIN2,K_cos);
SENOIDE_SIMBOLOS2 = bi2de(SENOIDEBINPARALELO2)';
SENOIDEMOD2 = pskmod(SENOIDE_SIMBOLOS2,M_cos);
SENOIDEMOD_UP2 = rectpulse(SENOIDEMOD2,nsamp);


% ---------------------- CANAL TDM ------------------------

S1 = SENOIDEMOD_UP2;    % COSSENO MODULADO
S2 = IMOD_UP;        % Imagem modulada
S3 = SENOIDEMOD_UP;    % Seno modulada

tvet=3*max([length(S1) length(S2) length(S3)]); % Criando o vetor
vetorTDM = zeros(tvet,1);       % Preenchendo com zero as posicoes vazias

temp = S1;
S1 = zeros(tvet,1);
S1(1:length(temp)) = temp; 

temp = S2;
S2 = zeros(tvet,1);
S2(1:length(temp)) = temp; 

temp = S3;
S3 = zeros(tvet,1);
S3(1:length(temp)) = temp; 

clear temp;

% Multiplexacao
for i=0:(tvet/3-1)
    vetorTDM(3*i+1) = S1(i+1);  % Preenchendo o vetor com o audio
    vetorTDM(3*i+2) = S2(i+1);  % Preenchendo o vetor com a imagem  
    vetorTDM(3*i+3) = S3(i+1);  % Preenchendo o vetor com a senoide
end

% Acrescenteando ruido ao sinal
vetorTDMR = awgn(vetorTDM,snr,'measured');

% Demultiplexacao
for i=0:(tvet/3-1)
    S1(1+i) = vetorTDMR(1 + i*3);   % Repreenchendo o vetor de audio
    S2(1+i) = vetorTDMR(2 + i*3);   % Repreenchendo o vetor de imagem
    S3(1+i) = vetorTDMR(3 + i*3);   % Repreenchendo o vetor de senoide
end

S1 = S1(1:length(SENOIDEMOD_UP2));
S2 = S2(1:length(IMOD_UP));
S3 = S3(1:length(SENOIDEMOD_UP));

% ------------------------ RECEPTOR -------------------------

% Imagem
I_DOWN = intdump(S2,nsamp);
IMR = pskdemod(I_DOWN,M_im);  
%IMR = qamdemod(S2,M_im);    
IMRBIN = de2bi(IMR); %SERIAL RECEBIDO
IREC = conv_imagem(IMRBIN,x,y);
% 
% % Audio
% AUDIO_DOWN = intdump(S1,nsamp);
% AUDIOR = oqpskdemod(AUDIO_DOWN,M_audio);
% %AUDIOR = qamdemod(S1,M_audio);
% AUDIORBIN = de2bi(AUDIOR);
% AUDIORBIN = reshape(AUDIORBIN',size(AUDIORBIN,1)*size(AUDIORBIN,2),1);
% AUDIOREC = conv_audio(AUDIORBIN,amp,abso,8);
% dt2 = 1/Fs;                          % Periodo de amostragem
% t2 = (0:dt2:(length(AUDIOREC)-1)*dt2).';      % Gera o vetor tempo
% %audiorecuperado = audiowrite('audiorecuperado.wav');
% sound(AUDIOREC,Fs);
% Senoide
SENOIDE_DOWN2 = intdump(S1,nsamp);
SENOIDER2 = pskdemod(SENOIDE_DOWN2,M_cos);
SENOIDERBIN2 = de2bi(SENOIDER2);
SENOIDERBIN2 = reshape(SENOIDERBIN2',size(SENOIDERBIN2,1)*size(SENOIDERBIN2,2),1);
SENOIDEREC2 = conv_audio(SENOIDERBIN2,amplitudecos,absolutocos,8);

% Senoide
SENOIDE_DOWN = intdump(S3,nsamp);
SENOIDER = qamdemod(SENOIDE_DOWN,M_sen);
%SENOIDER = qamdemod(S3,M_sen);
SENOIDERBIN = de2bi(SENOIDER);
SENOIDERBIN = reshape(SENOIDERBIN',size(SENOIDERBIN,1)*size(SENOIDERBIN,2),1);
SENOIDEREC = conv_audio(SENOIDERBIN,amplitude,absoluto,8);

% ---------------------- PLOTS ---------------------

% Plot das senoides
figure(1)
subplot(2,1,1)          % Senoide original
plot(t_sen,SENOIDE);
title('Senoide Original');
subplot(2,1,2)          % Senoide recuperada
title('Senoide Recuperada');
plot(t_sen,SENOIDEREC);

% Plot das imagens
figure(2)
subplot(1,2,1)          % Imagem original
imshow(SalvaImagem);
subplot(1,2,2)          % Imagem recuperada
imshow(IREC);       

% Plot das senoides
figure(1)
subplot(1,1,2)          % Senoide original
plot(t_cos,SENOIDE2);
title('Senoide Original');
subplot(2,1,2)          % Senoide recuperada
title('Senoide Recuperada');
plot(t_cos,SENOIDEREC2);


% Plot da imagem no dominio do tempo
figure(4)
plot(real(IMOD_UP(1:nsamp*50))) % plota o sinal modulado
hold on
plot(real(S2(1:nsamp*50)),'r') % plota o sinal ruidoso

% % Plot do audio no dominio do tempo
% figure(5)
% plot(real(AUDIOMOD_UP(1:nsamp*50))) % plota o sinal modulado
% hold on
% plot(real(S1(1:nsamp*50)),'r') % plota o sinal ruidoso

% Plot da senoide no dominio do tempo
figure(6)
plot(real(SENOIDEMOD_UP(1:nsamp*250))) % plota o sinal modulado
hold on
plot(real(S3(1:nsamp*250)),'r') % plota o sinal ruidoso

% Plot da senoide no dominio do tempo
figure(6)
plot(real(SENOIDEMOD_UP2(1:nsamp*250))) % plota o sinal modulado
hold on
plot(real(S1(1:nsamp*250)),'r') % plota o sinal ruidoso

% Scartterplot
scatterplot(S2);    % Imagem
scatterplot(S1);    % cosseno
scatterplot(S3);    % Senoide

% % Eyediagram
% if nsamp == 1
%     offset = 0;
%     h =  eyediagram(real(I_DOWN),2,1,offset);
%     g =  eyediagram(real(AUDIO_DOWN),2,1,offset);
%     f =  eyediagram(real(SENOIDE_DOWN),2,1,offset);
% else
%     offset = 2;
%     h =  eyediagram(real(I_DOWN),3,1,offset);
%     g =  eyediagram(real(AUDIO_DOWN),3,1,offset);
%     f =  eyediagram(real(SENOIDE_DOWN),3,1,offset);
% end
% 
% set(h,'Name','Diagram de Olho com Offset');     % EyeDiagram da imagem
% set(g,'Name','Diagram de Olho com Offset');     % EyeDiagram do audio
% set(f,'Name','Diagram de Olho com Offset');     % EyeDiagram da senoide

% Calculo dos erros
erro_im = 0;
erro_cos = 0;
erro_sen = 0;

A = reshape(IMRBIN',size(IMRBIN,1)*size(IMRBIN,2),1);

for i=1:length(A)
    if(IBIN(i) ~= A(i))
             erro_im = erro_im+1;
    end
end

BER_IM = erro_im/(size(IMRBIN,1)*size(IMRBIN,2));

A = reshape(AUDIORBIN',size(AUDIORBIN,1)*size(AUDIORBIN,2),1);

% for i=1:length(A)
%     if(AUDIO(i) ~= A(i))
%              erro_audio = erro_audio+1;
%     end
% end
% 
% BER_AUDIO = erro_audio/(size(AUDIO,1)*size(AUDIO,2));
% 
% A = reshape(SENOIDERBIN',size(SENOIDERBIN,1)*size(SENOIDERBIN,2),1);

for i=1:length(A)
    if(SENOIDEBIN(i) ~= A(i))
             erro_sen = erro_sen+1;
    end
end

BER_SENOIDE = erro_sen/(size(SENOIDEBIN,1)*size(SENOIDEBIN,2));

for i=1:length(A)
    if(SENOIDEBIN2(i) ~= A(i))
             erro_cos = erro_cos+1;
    end
end

BER_SENOIDE2 = erro_cos/(size(SENOIDEBIN2,1)*size(SENOIDEBIN2,2));

% Plot da imagem no dominio da frequencia
ta=1/Fs;     % Periodo de amostragem
%tam=1024;   % Tamanho de cada vetor
%Nf=2^18;    % Tamanho da fft
[Xf,xt,f,df] = fft_pot2(IMOD,ta);
figure(10)
plot(f,fftshift(db(abs(Xf))));





