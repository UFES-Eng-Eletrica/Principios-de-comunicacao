%
%%%%%%% SIMULA Sistema de Modulação Digital %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Lab VI - Modulação Digital em Banda Base e Banda Passante
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
M = 16; % Nível da modulação
k = log2(M); % bits por símbolo
n = 30000; % Numero de bits da Sequencia (Bitstream)
nsamp = 4; % Taxa de Oversampling
snr = 25; % Vetor SNR em dB
tp = 0; % 0-PAM, 1-PSK, 2-QAM

%&&&&&&&&&&&& Simulação do Sistema &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&%
%
disp('...................................................................')
disp('............... Modulação Digital .................................')
%
% ********************* TRANSMISSÃO ***************************************
%
% Gera o Bitstream
x = randint(n,1,M);

% Modulação
%if tp == 0
 % Modulação (M-PAM)
 xmod = pammod(x,M); % mapeamento 
%end

% Reamostragem (upsample)
x_up = rectpulse(xmod,nsamp);

% *********************** CANAL *******************************************
% Adiciona ruído Gaussiano branco ao sinal
y_ruido = awgn(x_up,snr,'measured');

% *************************************************************************
% ********************** RECEPÇÃO *****************************************
% Reamostragem (downsample)
y_down = intdump(y_ruido,nsamp);

% Demodulação
if tp == 0
 % Demodulação (M-PAM)
 y = pamdemod(y_down,M); % Demapeamento
end

%******************* Calcula os erros ************************************* 
d_bit = (abs(x-y));
n_erros = sum(d_bit);
ber_awgn = mean(d_bit);


% ------------------------- Mostra alguns Gráficos ------------------------
% Plota os sinais no dominio do Tempo
figure
plot(real(x_up(1:nsamp*50))) % plota o sinal modulado
hold on
plot(real(y_ruido(1:nsamp*50)),'r') % plota o sinal ruidoso

% Mostra o diagram de olho na saída do canal
if nsamp == 1
 offset = 0;
 h = eyediagram(real(y_down),2,1,offset);
else
 offset = 2;
 h = eyediagram(real(y_down),3,1,offset);
end
set(h,'Name','Diagram de Olho sem Offset');

% Mostra o Diagrama de Constelação
scatterplot(y_down,'.')


%************** Mostra Resultados Provisórios na Tela *********************
%
disp(sprintf('SNR: %4.1f dB',snr));
disp(sprintf('BER: %5.1e ',ber_awgn));
disp(sprintf('Qtd de erros: %3d',n_erros));
%
disp('...................................................................')
%
% 
...................................................................
............... Modulação Digital .................................
%SNR: 25.0 dB
%BER: 0.0e+000
%Qtd de erros: 0
...................................................................