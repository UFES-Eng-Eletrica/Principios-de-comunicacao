% 02/05/2019

%% Parâmetros

M=      64;
k=      log2(M);
n=      300e3;
nsamp=  1;
snr=    26;

%% Processamento

x = randi([0 M-1], 1, n);
% Modulação
    % Modulação (M-PAM)
    xmod = qammod(x,M);
    % mapeamento
    
x_up = rectpulse(xmod,nsamp);
y_ruido = awgn(x_up,snr,'measured');
y_down = intdump(y_ruido,nsamp);
y = qamdemod(y_down,M);  

%% Cálculo dos erros
d_bit    = (abs(x-y));
n_erros  = sum(d_bit);
ber_awgn = mean(d_bit);
n_erros/n


%% Plotagem
close all
%plot(real(x_up(1:nsamp*50)))  
%hold on
%plot(real(y_ruido(1:nsamp*50)),'r')

offset = 2;
%h =  eyediagram(real(y_ruido),3,1,offset);
%scatterplot(y_down)
%figure;
%plot(real(y_down), imag(y_down), 'r.', real(xmod),imag(xmod),'bo')