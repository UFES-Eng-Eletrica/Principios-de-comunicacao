clear all; clc; close all;
%
%...................... Parametros de Entrada .............................
M = 2; % Nível da modulação
k = log2(M); % bits por simbolo
n = 3000; % Numero de bits da Sequencia (Bitstream)
nsamp = 4; % Taxa de Oversampling
snr = 10; % Vetor SNR em dB
Rb = 10e6; % Taxa de transmissao

%&&&&&&&&&&&& Simulação do Sistema &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&%
%
disp('...................................................................')
disp('............... Modulação Digital .................................')
%
% ********************* TRANSMISSÃO ***************************************
%
% Gera o Bitstream
%x = randi([0 M-1],n,1); 
imagem = imread('foto.jpg');       % leitura da imagem em escla de cinza
imagem = imagem(:, :, 1);
imshow(imagem);                       % mostra a imagem original (figura 1)
vetor_im = imagem(:);                 % transforma em vetor
vetor_im = vetor_im';                 % transforma em vetor coluna
vetor_im = double(vetor_im);
[linhas colunas] = size(imagem);
x = de2bi(vetor_im, 8, 'left-msb');

x = reshape(x.', 1, []); % Transformando a matriz em vetor linha

% Modulação

% Modulação (M-PAM)
xmod = pammod(x,M); % mapeamento

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

% Demodulação (M-PAM)
y = pamdemod(y_down,M);
% Demapeamento
figure;                                       % figura 2

y_reshape = reshape(y,8, length(y)/8)';
y_dec = bi2de(y_reshape, 'left-msb');

imag_demod = uint8(y_dec);              % transforma para inteiro 
[imagem_demod,paded] = vec2mat(imag_demod,linhas); % transforma em matriz
imagem_demod = imagem_demod';                 % trabalha a matriz
imshow(imagem_demod);                         % mostra a imagem demodulada

%******************* Calcula os erros *************************************
d_bit = (abs(x-y));
n_erros = sum(d_bit);
ber_awgn = mean(d_bit);
% ------------------------- Mostra alguns Gráficos ------------------------
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
   % h = eyediagram(real(y_down),2,1,offset);
else
    offset = 2;
   % h = eyediagram(real(y_down),3,1,offset);
end
%set(h,'Name','Diagram de Olho sem Offset');
% Mostra o Diagrama de Constelação
%scatterplot(y_down)

%dt = 1/(nsamp * Rb);
%[Espectro,mn,f,df] = FFT_pot2(x_up(:,1).',dt);
%figure
%plot(f,10*log10(fftshift(abs(Espectro))),'b*')
%title ('Espectro de Potencia em Banda Base');
%xlabel('Frequencia [Hz]')
%ylabel('PSD [dB/Hz]')
%axis tight, grid

%hold on
%[Espectro2,mn,f2,df] = FFT_pot2(y_ruido(:,1).',dt);
%plot(f2,10*log10(fftshift(abs(Espectro2))),'r.')



%************** Mostra Resultados Provisórios na Tela *********************
%
disp(sprintf('SNR: %4.1f dB',snr));
disp(sprintf('BER: %5.1e ',ber_awgn));
disp(sprintf('Qtd de erros: %3d',n_erros));
%
disp('...................................................................')
%
%