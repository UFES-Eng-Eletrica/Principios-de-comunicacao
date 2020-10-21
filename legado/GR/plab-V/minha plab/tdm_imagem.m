clc, clear all, close all;
%
%...................... Parametros de Entrada .............................
M = 2; % Nível da modulação
k = log2(M); % bits por símbolo
n = 3000; % Numero de bits da Sequencia (Bitstream)
nsamp = 4; % Taxa de Oversampling
Ebn0 = 0;          %energia do bit de ruido  em dB
Esn0 = Ebn0 + 10*log10(log2(M)); 
snr = Esn0 - 10*log10(nsamp) + 3;       % Vetor SNR em dB
Rb = 1e6;   %taxa de transmissão dos bits = 1Mbps
Tb = 1/Rb;  %periodo de amostragem
fs = 8000;


%&&&&&&&&&&&& Simulação do Sistema &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&%
%
disp('...................................................................')
disp('............... Modulação Digital .................................')
%
% ********************* TRANSMISSÃO ***************************************
%
% ............ Geracao do sinal modulante .................................
figure();
subplot(2,3,1);
imagem1 = imread('gato.jpg');          % leitura da imagem em escla de cinza
[tam_x1,tam_y1] = size(imagem1);                 % encontra o tamanho da matriz pixels
imshow(imagem1);                       % mostra a imagem original (figura 1)
vetor_im1 = reshape(imagem1.',1,[]);                 % transforma em vetor
vetor_im1 = vetor_im1.';                 % transforma em vetor coluna
m1 = double(vetor_im1);                 % transforma de inteiro para double
x1 = de2bi(m1,8);              % vetor serializado e convertido em bits
x_vec1 = reshape(x1.',1,tam_x1);

subplot(2,3,2);
imagem2 = imread('fotoplab2.jpg');          % leitura da imagem em escla de cinza
[tam_x2,tam_y2] = size(imagem2);                 % encontra o tamanho da matriz pixels
imshow(imagem2);                       % mostra a imagem original (figura 1)
vetor_im2 = reshape(imagem2.',1,[]);                 % transforma em vetor
vetor_im2 = vetor_im2.';                 % transforma em vetor coluna
m2 = double(vetor_im2);                 % transforma de inteiro para double
x2 = de2bi(m2,8);              % vetor serializado e convertido em bits
x_vec2 = reshape(x2.',1,[]);

subplot(2,3,3)
imagem3 = imread('gatissimo.jpg');          % leitura da imagem em escla de cinza
[tam_x3,tam_y3] = size(imagem3);                 % encontra o tamanho da matriz pixels
imshow(imagem3);                       % mostra a imagem original (figura 1)
vetor_im3 = reshape(imagem3.',1,[]);                 % transforma em vetor
vetor_im3 = vetor_im3.';                 % transforma em vetor coluna
m3 = double(vetor_im3);                 % transforma de inteiro para double
x3 = de2bi(m3,8);              % vetor serializado e convertido em bits
x_vec3 = reshape(x3.',1,[]);

%% Multiplexacao das tres imagens
cont = 1;
x = zeros(1,3*length(x_vec1));              % x Ã© o vetor com as tres senoides
for ii = 1:length(x_vec1)
    x(cont) = x_vec1(ii);
    x(cont+1) = x_vec2(ii);
    x(cont+2) = x_vec3(ii);
    cont = cont+3;
end

% Modulacao (PAM-2)
xmod = pammod(x,M);

% Reamostragem (upsample)
x_up = rectpulse(xmod,nsamp);

% *********************** CANAL *******************************************
% Adiciona ruido Gaussiano branco ao sinal
y_ruido = awgn(x_up,snr,'measured');

% *************************************************************************


% ********************** RECEPCAO *****************************************
% Reamostragem (downsample)
y_down = intdump(y_ruido,nsamp);

% Demodulacao (M-PAM)
y = pamdemod(y_down,M); % Demapeamento

%% Demultiplexacao das tres imagens 
cont = 1;
for ii = 1:length(x_vec1)
    im1_final(ii) = y(cont);
    im2_final(ii) = y(cont+1);
    im3_final(ii) = y(cont+2);
    cont = cont + 3;
end

% ================ Mostra a imagem demodulada =============================
subplot(2,3,4);
y_bin1 = reshape(im1_final,8,[]);
y_bin1 = y_bin1.';
y_dec1 = bi2de(y_bin1);
% figure;                                       % figura 2
imag_demod1 = uint8(y_dec1);              % transforma para inteiro 
[imagem_demod1,paded] = vec2mat(imag_demod1,tam_y1); % transforma em matriz
imshow(imagem_demod1);

subplot(2,3,5);
y_bin2 = reshape(im2_final,8,[]);
y_bin2 = y_bin2.';
y_dec2 = bi2de(y_bin2);
% figure;                                       % figura 2
imag_demod2 = uint8(y_dec2);              % transforma para inteiro 
[imagem_demod2,paded] = vec2mat(imag_demod2,tam_y2); % transforma em matriz
imshow(imagem_demod2);

subplot(2,3,6);
y_bin3 = reshape(im3_final,8,[]);
y_bin3 = y_bin3.';
y_dec3 = bi2de(y_bin3);
% figure;                                       % figura 2
imag_demod3 = uint8(y_dec3);              % transforma para inteiro 
[imagem_demod3,paded] = vec2mat(imag_demod3,tam_y3); % transforma em matriz
imshow(imagem_demod3);


