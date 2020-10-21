%%%%%%% SIMULA Sistema de Modulação Digital %%%%%%%%%%%%%%%%%%%%%%%%%%%%%% %
%
% Lab VI
%Modulação Digital em Banda Base e Banda Passante
%          Banda Base: com pammod
%          Banda Passante: pskmod ou qammod
%
% Para PC I
% By: Daniel Sarnaglia Viegas da Fonseca
%
%UFES 2018
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%% %%%%%%%%%%%%%%%
%
clc, clear all, close all;
%
%...................... Parametros de Entrada .............................
M      = 2;           % Nível da modulação
k      = log2(M);     % bits por símbolo
n      = 30000;        % Numero de bits da Sequencia (Bitstream)
nsamp  = 4;           % Taxa de Oversampling
Ebno   = 8;           % Vetor SNR em dB
Rb     = 1.0e6;      %Taxa de Sinalização
Tb     = 1/Rb;        %Periodo do Bit
Rs     = Rb/k;        %Numero de Simbolos

%pmod, 

%&&&&&&&&&&&& Simulação do Sistema &&&&&&&&&&&&&&&&&&&&&&&&&&&&&& &&&&&&&&&%
%
disp('........................ .............................. .............')
disp('............... Modulação Digital .............................. ...')
%
% ********************* TRANSMISSÃO ****************************** *********
%
snr=Ebno+10*log10(log2(M))-10*log10(nsamp)+3;
%Leitura da Imagem
BDD_in=imread('Daniel.bmp');
BDD_in=rgb2gray(BDD_in);
matriz_in=BDD_in(:);
matriz_bin = de2bi(matriz_in);
matriz_bin=matriz_bin(:);    
%Dando uma Entrada
x =matriz_bin;
% Modulação (M-PAM)
xmod  = pammod(x,M);    % mapeamento
% Reamostragem (upsample)
x_up = rectpulse(xmod,nsamp);
figure(1)
plot(x_up)

figure(2)
% Adiciona ruído Gaussiano branco ao sinal
y_ruido = awgn(x_up,snr,'measured');


% ********************** RECEPÇÃO ****************************** ***********
% Reamostragem (downsample)
y_down = intdump(y_ruido,nsamp);
% Demodulação
% Demodulação (M-PAM)
y = pamdemod(y_down,M);       % Demapeamento
y_calc=uint8(y);
y=reshape(y,[],8);
y_in=uint8(bi2de(y));

DDD_out=reshape(y_in,[],size( BDD_in,2));
imshow(DDD_out);
imwrite(DDD_out,'teste.tif');

%******************* Calcula os erros ****************************** *******
d_bit    = (abs(x-y_calc));
n_erros  = sum(d_bit);
ber_awgn = mean(d_bit);

%************** Mostra Resultados Provisórios na Tela *********************
%
disp(sprintf('SNR: %4.1f dB',snr));
disp(sprintf('BER: %5.1e ',ber_awgn));
disp(sprintf('Qtd de erros: %3d',n_erros));
%
disp('........................ .............................. .............')
%
%