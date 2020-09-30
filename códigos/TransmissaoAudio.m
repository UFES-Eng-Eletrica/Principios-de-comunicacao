% 02/05/2019

%% Parâmetros

M=      4096;
k=      log2(M);
nsamp=  1;
snr=    50;

resolucao = 16;
offset = 1;

%% Processamento
% Transformação do Sinal de Áudio para Sinal pronto para modulação
data_mod = (data+offset)*(2^resolucao);
data_bin = de2bi(data_mod);
[lin, col] = size(data_bin);
data_cod = reshape(data_bin.', k, []);
x = bi2de(data_cod');

% Modulação
xmod = qammod(x,M);

% Transmissão
x_up = rectpulse(xmod,nsamp);
y_ruido = awgn(x_up,snr,'measured');
y_down = intdump(y_ruido,nsamp);
y = qamdemod(y_down,M);  

% Trasformação do Sinal de saída para Sinal de áudio
y_cod = de2bi(y);
y_bin = reshape(y_cod.', col, []);
y_mod = bi2de(y_bin');
y_decod = y_mod/(2^resolucao)-offset;

%% Cálculo dos erros
d_bit    = (abs(x-y));
n_erros  = sum(d_bit);
ber_awgn = mean(d_bit);
%n_erros/n


%% Plotagem
close all
plot(real(x_up(1:nsamp*50)))  
hold on
plot(real(y_ruido(1:nsamp*50)),'r')

offset = 2;
figure
%h =  eyediagram(real(y_ruido),3,1,offset);
%scatterplot(y_down)
%figure;
plot(real(y_down), imag(y_down), 'r.', real(xmod),imag(xmod),'bo')