% 02/05/2019

%% Par�metros

M=      16;
k=      log2(M);
nsamp=  1;
snr=    20;


%% Processamento
% Transforma��o do Sinal de �udio para Sinal pronto para modula��o
imagem_pb = rgb2gray(lena_std);
imagem_pb = double(imagem_pb);
[lin, col] = size(imagem_pb);
imagem_lin = reshape(imagem_pb, lin*col, []);
imagem_bin = de2bi(imagem_lin);
[lin2,col2] = size(imagem_bin);
imagem_cod = reshape(imagem_bin.', k, []);
x = bi2de(imagem_cod');

% Modula��o
xmod = qammod(x,M);

% Transmiss�o
x_up = rectpulse(xmod,nsamp);
y_ruido = awgn(x_up,snr,'measured');
y_down = intdump(y_ruido,nsamp);
y = qamdemod(y_down,M);  

% Trasforma��o do Sinal de sa�da para Sinal de �udio
y_cod = de2bi(y,k);
y_cod = y_cod';
y_bin = reshape(y_cod, col2, []);
y_mod = bi2de(y_bin');
y_final = reshape(y_mod, col, []);
y_final = uint8(y_final);

%% C�lculo dos erros
% d_bit    = (abs(x-y));
% n_erros  = sum(d_bit);
% ber_awgn = mean(d_bit);
% n_erros/n


%% Plotagem
close all
plot(real(x_up(1:nsamp*50)))  
hold on
plot(real(y_ruido(1:nsamp*50)),'r')

offset = 2;
figure
scatterplot(y_down)
figure;
plot(real(y_down), imag(y_down), 'r.', real(xmod),imag(xmod),'bo')