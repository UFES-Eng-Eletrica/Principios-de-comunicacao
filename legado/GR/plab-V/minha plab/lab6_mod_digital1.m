%
%%%%%%% SIMULA Sistema de Modula��o Digital %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Lab VI - Modula��o Digital em Banda Base e Banda Passante
% Banda Base: com pammod
% Banda Passante: pskmod ou qammod
%
% Para PC I
% By: Prof. Jair Silva
% UFES 2014
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
clc, clear all, close all;
%
%...................... Parametros de Entrada .............................
M = 4; % N�vel da modula��o
k = log2(M); % bits por s�mbolo = log2(M)=1
n = 5000000; % Numero de bits da Sequencia (Bitstream)
nsamp = 4; % Taxa de Oversampling
snr = 7.88; % Vetor SNR em dB
tp = 2; % 0-PAM, 1-PSK, 2-QAM

%&&&&&&&&&&&& Simula��o do Sistema &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&%
%
disp('...................................................................')
disp('............... Modula��o Digital .................................')
%
% ********************* TRANSMISS�O ***************************************
%
% Gera o Bitstream
x = randi([0 M-1], 1, n ); %0 a M-1 � o n�merode bits por inteiro lido
% Modula��o
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

% Reamostragem (upsample)
x_up = rectpulse(xmod,nsamp); 
%x_up=xmod;% sem rectpulse
% *********************** CANAL *******************************************
% Adiciona ru�do Gaussiano branco ao sinal
y_ruido = awgn(x_up,snr,'measured');

% *************************************************************************
% ********************** RECEP��O *****************************************
% Reamostragem (downsample)
y_down = intdump(y_ruido,nsamp);
%y_down=y_ruido;%sem intdump
% Demodula��o
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

%******************* Calcula os erros ************************************* 
d_bit = (abs(x-y));
n_erros = sum(d_bit);
ber_awgn = mean(d_bit);


% ------------------------- Mostra alguns Gr�ficos ------------------------
% Plota os sinais no dominio do Tempo
figure
%plot(real(x_up(1:nsamp*50))) % plota o sinal modulado. para =3 milhoes
% � preciso comentar os gr�ficos
hold on
%plot(real(y_ruido(1:nsamp*50)),'r') % plota o sinal ruidoso. para n
%=3milh�es � preciso comentar os gr�ficos

% Mostra o diagram de olho na sa�da do canal
%para fazer para n=1milh�o ,devemos comentar tudo abaixo
%if nsamp == 1
 %offset = 0;
 %h = eyediagram(real(y_down),2,1,offset);
%else
 %offset = 2;
 %h = eyediagram(real(y_down),3,1,offset);
%end
%set(h,'Name','Diagram de Olho sem Offset');

% Mostra o Diagrama de Constela��o
%scatterplot(y_down) %� preciso manter a dist�ncia euclidiana para
%diferentes valores de M(a dist�ncia � sempre 2)


%************** Mostra Resultados Provis�rios na Tela *********************
%
disp(sprintf('SNR: %4.1f dB',snr));
disp(sprintf('BER: %5.1e ',ber_awgn));
disp(sprintf('Qtd de erros: %3d',n_erros));
%
disp('...................................................................')
%
% 
...................................................................
............... Modula��o Digital .................................
%SNR: 25.0 dB
%BER: 0.0e+000; voz -> e-03; dado/�udio -> e-06 ; fibra �tica -> e-12
%Qtd de erros: 0
...................................................................