%
%%%%%%%%%%%%%%%% SIMULA BER x SNR %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Transmissao em Banda Base com Modula��o 2-PAM (NRZ bipolar)
%
% Para Principios de Comunicacoes I
%
% by Prof. Dr. Jair Silva
% Atualizado em 03/2015
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Inicializa��o
clc, clear all, close all
%
%...................... Parametros de Entrada .............................
%
n  = 30000;         % Numero de bits da Sequencia (Bitstream)
M  = 2;             % N�vel de modula��o
k  = log2(M);       % bits por s�mbolo
nsamp  = 4;         % Taxa Oversampling (Qtd de pontos para representar o bit)
snr  = 12;          % SNR em dB


% ************* TRANSMISS�O ***************************************
% Gera o Bitstream
% x = randint(n,1,M);
x = randi([0,M-1],n,1);

% Modula��o (M-PAM)
xmod = pammod(x,M);

% Convolucao com o filtro conformador
xmod_up = rectpulse(xmod,nsamp);


% *************** CANAL *******************************************

% Adiciona ru�do Gaussiano branco ao sinal
y_ruido  = awgn(xmod_up,snr,'measured');


% ************** RECEP��O *****************************************
% Convolucao com o filtro conformado na recepcao
y_r = intdump(y_ruido,nsamp);

% Demodula��o (M-PAM)
y = pamdemod(y_r,M);


%*********** Calcula os erros *************************************
isequal(x,y)


% ********* Plotagem dos sinais  *********************************
figure, plot(real(xmod_up(1:nsamp*50)))       % no tempo
hold on, plot(real(y_ruido(1:nsamp*50)),'r')
figure, plot(db(fftshift(abs(fft(xmod_up))))) % na frequencia

h =  eyediagram(real(y_r),3,1);


%
% Fim do script
%
