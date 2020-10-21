clear ;
clc;

%% Parametros de Entrada:
M1      = 8;            % Nível da modulação
k      = log2(M);      % bits por simbolo
n      = 3000;         % Numero de bits da Sequencia (Bitstream)
nsamp  = 4;            % Taxa de Oversampling
snr    = 30;            % Relacao Sinal-Ruido


%% Leitura e Conversão da Imagem:
imagem = imread('IMG_20180417_083951426.jpg');      % leitura da imagem em escla de cinza
imagem = rgb2gray(imagem);            % converte imagem para cinza
[linha,coluna] = size(imagem);        % encontra o tamanho da matriz pixels
imshow(imagem);                       % mostra a imagem original (figura 1)
title('Imagem Antiga')
vetor_im = imagem(:);                 % transforma em vetor
vetor_im = vetor_im';                 % transforma em vetor coluna
vetor_im = double(vetor_im);          % transforma de inteiro para double
x = de2bi(vetor_im);                  % Transforma decimal em bit

%% TransmissÃ£o:
% Modulação (M-PSK)
xmod = pskmod(x,M1); 
     
% Reamostragem (upsample)
x_up = rectpulse(xmod,nsamp);

%% Canal
% Adiciona ruído Gaussiano branco ao sinal
y_ruido = awgn(x_up,snr,'measured');

%% Recepção
% Reamostragem (downsample)
y_down = intdump(y_ruido,nsamp);

% Demodulação (M-PAM)
y = pskdemod(y_down,M);

%% Calculo dos erros
d_bit    = (abs(x-y));
n_erros  = sum(d_bit);
ber_awgn = mean(d_bit);

%% Mostra alguns Gráficos:

% Plota os sinais no dominio do Tempo
%figure
%plot(real(x_up(1:nsamp*50)))         % plota o sinal modulado
%hold on
%plot(real(y_ruido(1:nsamp*50)),'r')  % plota o sinal ruidoso

%Mostra o diagram de olho na saÃ­da do canal
%if nsamp == 1
%offset = 0;
%h =  eyediagram(real(y_down),2,1,offset);
%else
%offset = 2;
%h =  eyediagram(real(y_down),3,1,offset);
%end
%set(h,'Name','Diagram de Olho sem Offset');

% %Mostra o Espectro do sinal
% Tb = 1/Rb;
% [Sinal_ff,sinal_tf,f,df] = FFT_pot2(x_up,Tb);
% X=abs(Sinal_ff);
% p = plot(f,fftshift(X));

% Mostra o Diagrama de Constelação
%scatterplot(y_down,'.')

%%************** Mostra Resultados Provissórios na Tela *********************%
%disp(sprintf('SNR: %4.1f dB',snr));
%disp(sprintf('BER: %5.1e ',ber_awgn));
%disp(sprintf('Qtd de erros: %3d',n_erros));
%disp('...................................................................')

% ================ Mostra a imagem demodulada =============================
figure;                                            % figura 2
imag_demod = bi2de(y);                             % transforma de binario para decimal
imag_demod = uint8(imag_demod);                    % transforma para inteiro 
[imagem_demod,paded] = vec2mat(imag_demod,linha);  % transforma em matriz
imagem_demod = imagem_demod';                      % trabalha a matriz
imshow(imagem_demod);                              % mostra a imagem demodulada
title('Imagem Nova')