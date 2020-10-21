% Aluno: Wagner Trarbach Frank
% Principio de comunicação 1
% data: 05/06/2018

clear all; clc; close all;      % limpa Workspace, fecha imagens e limpa Command Window
%
% ===================== Parametros de Entrada =============================

M = 2;                      % Nível da modulação
k = log2(M);                % bits por simbolo
n = 30000;                   % Numero de bits da Sequencia (Bitstream)
nsamp = 4;                  % Taxa de Oversampling
Ebn0 = 10.5;                % SNR = Ebn0 + 10log10[log2(M)] - 10log10(nsamp) +3
snr = Ebn0 + 10*log10(log2(M)) - 10*log10(nsamp) +3;
Rb = 10e6;                  % Taxa de transmissao
Fs     = 1e6;               % Bw = 1M Hz  

% =================== Calculos Preliminares ===============================
Ts = 1/n;                        % Periodo de amostragem         
Tb    = 1/Rb;                     % Tempo pra cada bit

% ======================== Simulação do Sistema ===========================
%
disp('...................................................................')
disp('............... Modulação Digital .................................')
%
% ======================== TRANSMISSÃO ====================================

imagem = imread('foto.jpg');       % leitura da imagem em escla de cinza
imagem = imagem(:, :, 1);                  % pega todas as linhas e colunas
imshow(imagem);                            % mostra a imagem original (figura 1)
vetor_im = imagem(:);                      % transforma em vetor
vetor_im = vetor_im';                      % transforma em vetor coluna
vetor_im = double(vetor_im);
[linhas colunas] = size(imagem);
x = de2bi(vetor_im, 8, 'left-msb');     % transforma em binário

x = reshape(x.', 1, []);                % Transformando a matriz em vetor linha

Ts = 1/n;                               % Periodo de amostragem 
% ==========  Modulação Digital em Banda Base com pammod ==================

xmod = pammod(x,M);                     % mapeamento

x_up = rectpulse(xmod,nsamp);           % Reamostragem (upsample)

% ========================== CANAL ========================================

y_ruido = awgn(x_up,snr,'measured');    % Adiciona ruído Gaussiano branco ao sinal

% ========================== RECEPÇÃO =====================================

y_down = intdump(y_ruido,nsamp);        % Reamostragem (downsample)

t = (0:Ts:(length(y_down)-1)*Ts).';     % Gera o vetor tempo

% ========================== DEMODULAÇÃO ==================================
y = pamdemod(y_down,M);                 % Demodulação (M-PAM)
% Demapeamento
figure;                                 

y_reshape = reshape(y,8, length(y)/8)';
y_dec = bi2de(y_reshape, 'left-msb');

imag_demod = uint8(y_dec);                    % transforma para inteiro 
[imagem_demod,paded] = vec2mat(imag_demod,linhas); % transforma em matriz
imagem_demod = imagem_demod';                 % trabalha a matriz
imshow(imagem_demod);                         % mostra a imagem demodulada

% ========================= CALCULO DOS ERROS =============================
d_bit    = (abs(x-y));
n_erros = sum(d_bit);
ber_awgn = mean(d_bit);

% ==================== Calcula os espectros dos sinais ====================
[X,sinal_tf1,f1,df] = FFT_pot2(x_up.',Ts);     % Determina o espectro
[Y,sinal_tf2,f2,df] = FFT_pot2(y_down.',Ts);   % Determina o espectro

% ========================= Mostra alguns Gráficos ========================
% Plota os sinais no dominio do Tempo
figure
plot(real(x_up(1:nsamp*50)))
% plota o sinal modulado
hold on
plot(real(y_ruido(1:nsamp*50)),'r')
% plota o sinal ruidoso
% Mostra o diagram de olho na saída do canal
if nsamp == 1
    offset = 0;
   h = eyediagram(real(y_down),2,1,offset);
else
    offset = 2;
   h = eyediagram(real(y_down),3,1,offset);
end
set(h,'Name','Diagram de Olho sem Offset');
figure
subplot(2,1,1)
    plot(f1,10*log10(fftshift(abs(X))),'b'), grid on; hold on
        title ('Espectro do sinal modulado');
        xlabel('Frequencia[Hz]'), ylabel('PSD [dB/Hz]'), axis tight
subplot(2,1,2)
    plot(f2,10*log10(fftshift(abs(Y))),'r'), grid on
        title ('Espectro do sinal ruidoso');
        xlabel('Frequencia[Hz]'), ylabel('PSD [dB/Hz]'), axis tight
%Mostra o Diagrama de Constelação
scatterplot(y_down)

dt = 1/(nsamp * Rb);
[Espectro,mn,f,df] = FFT_pot2(x_up(:,1).',dt);
figure
plot(f,10*log10(fftshift(abs(Espectro))),'b*')
title ('Espectro de Potencia em Banda Base');
xlabel('Frequencia [Hz]')
ylabel('PSD [dB/Hz]')
axis tight, grid

hold on
[Espectro2,mn,f2,df] = FFT_pot2(y_ruido(:,1).',dt);
plot(f2,10*log10(fftshift(abs(Espectro2))),'r.')



%************** Mostra Resultados Provisórios na Tela *********************
%
disp(sprintf('SNR: %4.1f dB',snr));
disp(sprintf('BER: %5.1e ',ber_awgn));
disp(sprintf('Qtd de erros: %3d',n_erros));
%
disp('...................................................................')
%
