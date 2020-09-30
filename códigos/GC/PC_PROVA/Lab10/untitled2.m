% Principio de Comunicação - Laboratório 10.
% Wagner Trarbach Frank

clear all; close all; clc;  % limpa Workspace, fecha imagens e limpa Command Window

% =====  Modulação Digital em Banda Base e Banda Passanteo ================
%          Banda Base: com pammod
%          Banda Passante: pskmod ou qammod

% ===============  Parametros de Simulação ================================
M = 2;                  % Nível da modulação +V e -V.
k = log2(M);            % bits por símbolo
nsamp = 4;              % Taxa de Oversampling 
Ebn0 = 6;               % SNR = Ebn0 + 10log10[log2(M)] - 10log10(nsamp) +3
snr = Ebn0 + 10*log10(log2(M)) - 10*log10(nsamp) +3;
Fs = 1e6;                % Bw = 1M Hz   

% =================== Calculos Preliminares ===============================
        

Rb = 1e6;                     % Taxa de bits por segundo;
Tb = 1/Rb;                    % Tempo pra cada bit
f1 = 1000;                       
f2 = 2*f1;
f3 = 3*f1;
ta  = 1/Fs;                   % Periodo de amostragem dos sinais em banda base
tam = 1000;                   % Tamanho dos vetores 
t  = (0:ta:(tam-1)*ta);         % Cria o novo vetor tempo j� em banda passante
Ts = 1/Fs;                    % Periodo de amostragem   

% ================== Simulação do Sistema =================================

disp('...................................................................')
disp('............... Modulação Digital .................................')

% ========================= TRANSMISSÃO/MODULAÇÃO =========================

% Primeiro sinal em Banda Base (Fonte I)
s1  = cos(2*pi*f1*t);  % primeiro sinal a ser multiplexado 

% Segundo sinal em Banda Base (Fonte II)
s2  = 2*cos(2*pi*f2*t);  % segundo sinal a ser multiplexado 

% Terceiro sinal em Banda Base (Fonte III)
s3  = 3*cos(2*pi*f3*t);  % segundo sinal a ser multiplexado 

quant = max(s1)/(2^7-1);
y1 = round(s1/quant);
sign1 = uint8((sign(y1)'+1)/2)
out1 = [ sign1 de2bi(abs(y1),7)];
out1 = reshape(out1.', 1, []); % Transformando a matriz em vetor linha

quant2 = max(s2)/(2^7-1);
y2 = round(s1/quant2);
sign2 = uint8((sign(y2)'+1)/2)
out2 = [ sign2 de2bi(abs(y2),7)];
out2 = reshape(out2.', 1, []); % Transformando a matriz em vetor linha

quant3 = max(s3)/(2^7-1);
y3 = round(s1/quant3);
sign3 = uint8((sign(y3)'+1)/2)
out3 = [ sign3 de2bi(abs(y3),7)];
out3 = reshape(out3.', 1, []); % Transformando a matriz em vetor linha


% ========================== MULTIPLEXAÇÃO ================================
cont = 1;
x=zeros(1,24000);
for ii=1:8000
    x(cont) = out1(ii);
    x(cont+1) = out2(ii);
    x(cont+2) = out3(ii);
    cont = cont+3;
end
% x1 = x(:)
% x = de2bi(x1,8,'left-msb');
% xmod = pammod(x.',M);     % mapeamento
% 
% x_up = rectpulse(xmod,nsamp);  % Reamostragem (upsample)
% 
% % ======================== CANAL ==========================================
% y_ruido = awgn(x_up,snr,'measured');    % Adiciona ruído Gaussiano branco ao sinal
% 
% % =========================RECEPÇÃO =======================================
% y_down = intdump(y_ruido,nsamp);    % Reamostragem (downsample)
% 
% %t = (0:Ts:(length(y_down)-1)*Ts).';     % Gera o vetor tempo
% 
% % ===================== Demodulação (PAM) =================================
% y = pamdemod(y_down,M);       % Demapeamento
% 
% % ===================== Calcula os erros ==================================
% d_bit    = (abs(x-y));
% n_erros  = sum(d_bit);
% ber_awgn = mean(d_bit);
% 
% % ==================== Calcula os espectros dos sinais ====================
% [X,sinal_tf1,f1,df] = FFT_pot2(x_up.',Ts);  % Determina o espectro
% [Y,sinal_tf2,f2,df] = FFT_pot2(y_down.',Ts);   % Determina o espectro
% 
% % ================== Plota os sinais no dominio do Tempo ==================
% figure
% plot(real(x_up(1:nsamp*50)))  % plota o sinal modulado
% hold on
% plot(real(y_ruido(1:nsamp*50)),'r')  % plota o sinal ruidoso
% 
% % Mostra o diagram de olho na saída do canal
% if nsamp == 1
% offset = 0;
% h =  eyediagram(real(y_down),2,1,offset);
% else
% offset = 2;
% h =  eyediagram(real(y_down),3,1,offset);
% end
% set(h,'Name','Diagram de Olho sem Offset');
% figure
% subplot(2,1,1)
%     plot(f1,10*log10(fftshift(abs(X))),'b'), grid on; hold on
%         title ('Espectro do sinal modulado');
%         xlabel('Frequencia[Hz]'), ylabel('PSD [dB/Hz]'), axis tight
% subplot(2,1,2)
%     plot(f2,10*log10(fftshift(abs(Y))),'r'), grid on
%         title ('Espectro do sinal ruidoso');
%         xlabel('Frequencia[Hz]'), ylabel('PSD [dB/Hz]'), axis tight
% 
% % Mostra o Diagrama de Constelação
% scatterplot(y_down)
% %************** Mostra Resultados Provisórios na Tela *********************
% 
% disp(sprintf('SNR: %4.1f dB',snr));
% disp(sprintf('BER: %5.1e ',ber_awgn));
% disp(sprintf('Qtd de erros: %3d',n_erros));