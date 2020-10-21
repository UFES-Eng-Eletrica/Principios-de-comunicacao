%% =================== Sistema de modulacao digital PAM ===================
% Simulando um sistema de comunicao digital utilizando modulacao PAM
% 
% y         - saida do seu sistema de modulação PAM
% y_ruido   - saida do canal do sistema (incluindo o ruido obtido na 
%             transmissao no canal)
% Rb        - taxa de sinalizacao (transmissao) em [bits/seg]
% nsamp     - Taxa de Oversampling (numero de vezes que se repete o bit a 
%             ser transmitido)
% snr       - SNR eh a relacao sinal-ruido em dB
% tp        - ==0 � PAM; ==1 � PSK; ==2 � QAM
%
% =========================================================================

function [y,y_ruido] = Sist_modulacao_digital_PAM(x,Rb,nsamp,snr,M) 

% ============================== Parametros ===============================
M      = 2;             % Nível da modulação (quantos niveis de tensao
                        % existente para representar o sinal)
k      = log2(M);       % bits por símbolo

%========================= Simulação do Sistema ===========================

disp('...................................................................')
disp('...................... Modulação Digital ..........................')

% ========================= TRANSMISSÃO =========================

% Gera o Bitstream
%x = randi([0 M-1],1,n);


% Modulação
xmod = pammod(x,M);     % mapeamento

% Reamostragem (upsample)
x_up = rectpulse(xmod,nsamp);

% ========================= CANAL =========================
% Adiciona ruído Gaussiano branco ao sinal
y_ruido = awgn(x_up,snr,'measured');

% ========================= RECEPÇÃO =========================
% Reamostragem (downsample)
y_down = intdump(y_ruido,nsamp);
% Demodulação

% Demodulação (M-PAM)
y = pamdemod(y_down,M); % Demapeamento


% ============================ Calcula os erros ===========================
d_bit= (abs(x-y));
n_erros  = sum(d_bit);
ber_awgn = mean(d_bit);

% ===================== Calculo do espectro do sinnal ===================== 
tb=(1/Rb)/nsamp;
[Y,y2,f,df]=FFT_pot2(y_ruido,tb);

% % ========================= Plots =========================
% % Plota os sinais no dominio do Tempo
% figure
% plot(real(x_up(1:nsamp*50)))  % plota o sinal modulado
% hold on
% plot(real(y_ruido(1:nsamp*50)),'r')  % plota o sinal ruidoso
% 
% % Mostra o diagram de olho na saída do canal
% if nsamp == 1
%     offset = 0;
%     h =  eyediagram(real(y_down),2,1,offset);
% else
%     offset = 2;
%     h =  eyediagram(real(y_down),3,1,offset);
% end
% 
% set(h,'Name','Diagram de Olho sem Offset');
% 
% % Mostra o Diagrama de Constelação
% scatterplot(y_down)
% 
% % Plotando o espectro do sinal ruidoso na saida
% figure(4)
% plot(f,10*log10(fftshift(abs(Y))));
% xlabel('f[Hz]')
% ylabel('Amplitude [dB]') 
% title('Espectro do sinal ruidoso na saida em dB')
% grid on
% 

% ================ Mostra Resultados Provisórios na Tela ==================

disp(sprintf('SNR: %4.1f dB',snr));
disp(sprintf('BER: %5.1e ',ber_awgn));
disp(sprintf('Qtd de erros: %3d',n_erros));

disp('...................................................................')
%